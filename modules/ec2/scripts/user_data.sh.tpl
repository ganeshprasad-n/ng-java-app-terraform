#!/bin/bash
# Update system
yum update -y

# Install Java (required for Elasticsearch)
yum install -y java-11-amazon-corretto

# Install RabbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install -y rabbitmq-server
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

# Install Elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum install -y elasticsearch

# Configure Elasticsearch to listen on private IP
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch
systemctl start elasticsearch

systemctl restart elasticsearch