#!/bin/bash
# Update system
yum update -y

# Install AWS CLI
yum install -y awscli

# Download WAR from S3
aws s3 cp s3://ng-java-app-artifacts-staging/vprofile-v2.war /opt/tomcat/webapps/ROOT.war

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
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat