#!/bin/bash
# Update system
yum update -y

# Install dependencies
yum install -y amazon-efs-utils

# Mount EFS
mkdir -p /mnt/efs
mount -t efs ${efs_id}:/ /mnt/efs

# Copy WAR file from EFS to Tomcat (Tomcat already in AMI)
cp /mnt/efs/vprofile-v2.war /opt/tomcat/webapps/ROOT.war

# Configure application.properties with RDS/ElastiCache/Backend endpoints
cat > /opt/tomcat/webapps/application.properties <<EOF
jdbc.url=jdbc:mysql://${rds_endpoint}/accounts
jdbc.username=${db_user}
jdbc.password=${db_password}
memcached.active.host=${memcached_endpoint}
rabbitmq.address=${backend_ip}
elasticsearch.host=${backend_ip}
EOF

# Start Tomcat
systemctl start tomcat
systemctl enable tomcat