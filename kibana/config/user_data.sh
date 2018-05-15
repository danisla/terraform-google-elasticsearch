#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Configure cerebro
sudo sed -i -e 's|http://localhost:9200|${elasticsearch_url}|' /usr/share/cerebro/cerebro-*/conf/application.conf

systemctl daemon-reload
systemctl enable cerebro.service
service cerebro restart

# Configure elasticsearch
cat <<'EOF' >>/etc/kibana/kibana.yml
server.host: "0.0.0.0"
elasticsearch.url: ${elasticsearch_url}
xpack.security.enabled: ${security_enabled}
xpack.monitoring.enabled: ${monitoring_enabled}
EOF

systemctl daemon-reload
systemctl enable kibana.service
service kibana restart

sleep 60
if [ `systemctl is-failed kibana.service` == 'failed' ];
then
  echo "Kibana unit failed to start"
  exit 1
fi