#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Configure elasticsearch
cat <<'EOF' >>/etc/elasticsearch/elasticsearch.yml
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
path.data: ${elasticsearch_data_dir}
path.logs: ${elasticsearch_logs_dir}
EOF

cat <<'EOF' >>/etc/security/limits.conf

# allow user 'elasticsearch' mlockall
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
EOF

sudo mkdir -p /etc/systemd/system/elasticsearch.service.d
cat <<'EOF' >>/etc/systemd/system/elasticsearch.service.d/override.conf
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

sudo mkdir -p ${elasticsearch_data_dir}
sudo chown -R elasticsearch:elasticsearch ${elasticsearch_data_dir}

# Start Elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service


# Setup x-pack security also on Kibana configs where applicable
if [ -f "/etc/kibana/kibana.yml" ]; then
    echo "xpack.security.enabled: ${security_enabled}" | sudo tee -a /etc/kibana/kibana.yml
    echo "xpack.monitoring.enabled: ${monitoring_enabled}" | sudo tee -a /etc/kibana/kibana.yml
    systemctl daemon-reload
    systemctl enable kibana.service
    sudo service kibana restart
fi

sleep 60
if [ `systemctl is-failed elasticsearch.service` == 'failed' ];
then
    echo "Elasticsearch unit failed to start"
    exit 1
fi