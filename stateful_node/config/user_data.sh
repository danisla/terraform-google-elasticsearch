#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Configure elasticsearch
cat <<'EOF' >/etc/elasticsearch/elasticsearch.yml
bootstrap.memory_lock: true
node.name: $${HOSTNAME}

action.destructive_requires_name: true
indices.fielddata.cache.size: 30%

cluster.name: ${cluster_name}

cloud:
  gce:
    project_id: ${project_id}
    zone: [${zones}]
discovery:
  zen.hosts_provider: gce
  
network.host: "0.0.0.0"
network.publish_host: "_gce:hostname_"

discovery.zen.minimum_master_nodes: ${minimum_master_nodes}

# only data nodes should have ingest and http capabilities
node.master: ${master}
node.data: ${data}
node.ingest: ${ingest}
http.enabled: ${http_enabled}
xpack.security.enabled: ${security_enabled}
xpack.monitoring.enabled: ${monitoring_enabled}
path.data:
  - /opt/elasticsearch/data1
  - /opt/elasticsearch/data2
  - /opt/elasticsearch/data3
  - /opt/elasticsearch/data4
path.logs: ${elasticsearch_logs_dir}
EOF

# Set the zone for shard allocation awareness.
ZONE=$(basename $(curl -sf -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/zone)) 
echo "node.attr.zone: $ZONE" >> /etc/elasticsearch/elasticsearch.yml

if [[ "${master}" == "true" ]]; then
    echo "cluster.routing.allocation.awareness.attributes: zone" >> /etc/elasticsearch/elasticsearch.yml
fi

cat <<'EOF' >/etc/security/limits.conf

# allow user 'elasticsearch' mlockall
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
EOF

sudo mkdir -p /etc/systemd/system/elasticsearch.service.d
cat <<'EOF' >/etc/systemd/system/elasticsearch.service.d/override.conf
[Service]
LimitMEMLOCK=infinity
EOF

# Setup heap size and memory locking
sudo sed -i 's/#MAX_LOCKED_MEMORY=.*$/MAX_LOCKED_MEMORY=unlimited/' /etc/init.d/elasticsearch
sudo sed -i 's/#MAX_LOCKED_MEMORY=.*$/MAX_LOCKED_MEMORY=unlimited/' /etc/default/elasticsearch
sudo sed -i "s/^-Xms.*/-Xms${heap_size}/" /etc/elasticsearch/jvm.options
sudo sed -i "s/^-Xmx.*/-Xmx${heap_size}/" /etc/elasticsearch/jvm.options

# Storage
sudo mkdir -p ${elasticsearch_logs_dir}
sudo chown -R elasticsearch:elasticsearch ${elasticsearch_logs_dir}

sudo mkdir -p /opt/elasticsearch
sudo chown -R elasticsearch:elasticsearch /opt/elasticsearch

# Format and mount disks
if [[ ! $(blkid /dev/disk/by-id/google-es-data-1) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-es-data-1
fi
if ! grep -q "/dev/disk/by-id/google-es-data-1" /etc/fstab; then
    echo "/dev/disk/by-id/google-es-data-1 /opt/elasticsearch/data1     ext4    defaults 0 0" >> /etc/fstab
fi

if [[ ! $(blkid /dev/disk/by-id/google-es-data-2) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-es-data-2
fi
if ! grep -q "/dev/disk/by-id/google-es-data-2" /etc/fstab; then
    echo "/dev/disk/by-id/google-es-data-2 /opt/elasticsearch/data2     ext4    defaults 0 0" >> /etc/fstab
fi

if [[ ! $(blkid /dev/disk/by-id/google-es-data-3) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-es-data-3
fi
if ! grep -q "/dev/disk/by-id/google-es-data-3" /etc/fstab; then
    echo "/dev/disk/by-id/google-es-data-3 /opt/elasticsearch/data3     ext4    defaults 0 0" >> /etc/fstab
fi

if [[ ! $(blkid /dev/disk/by-id/google-es-data-4) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-es-data-4
fi
if ! grep -q "/dev/disk/by-id/google-es-data-4" /etc/fstab; then
    echo "/dev/disk/by-id/google-es-data-4 /opt/elasticsearch/data4     ext4    defaults 0 0" >> /etc/fstab
fi
mkdir -p /opt/elasticsearch/data{1,2,3,4}
mount -a
chown -R elasticsearch:elasticsearch /opt/elasticsearch/data{1,2,3,4}

# Start Elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

sleep 60
if [ `systemctl is-failed elasticsearch.service` == 'failed' ];
then
    echo "Elasticsearch unit failed to start"
    exit 1
fi