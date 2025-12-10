#!/bin/bash
set -e
exec > >(tee /var/log/app-user-data.log) 2>&1

echo "=== App Server User Data: $(date) ==="

REGION="us-east-1"

sleep 10

# Fetch app config from Parameter Store (shell variables)
DB_HOST=$(aws ssm get-parameter --name "/ng-java-app/db/host" --region "$REGION" --query 'Parameter.Value' --output text)
DB_PORT=$(aws ssm get-parameter --name "/ng-java-app/db/port" --region "$REGION" --query 'Parameter.Value' --output text)
CACHE_HOST=$(aws ssm get-parameter --name "/ng-java-app/cache/host" --region "$REGION" --query 'Parameter.Value' --output text)
RABBITMQ_HOST=$(aws ssm get-parameter --name "/ng-java-app/rabbitmq/host" --region "$REGION" --query 'Parameter.Value' --output text)
ES_HOST=$(aws ssm get-parameter --name "/ng-java-app/elasticsearch/host" --region "$REGION" --query 'Parameter.Value' --output text)

# Fetch WAR location from SSM
WAR_BUCKET=$(aws ssm get-parameter --name "/ng-java-app/artifacts/bucket" --region "$REGION" --query 'Parameter.Value' --output text)
WAR_KEY=$(aws ssm get-parameter --name "/ng-java-app/artifacts/war_key" --region "$REGION" --query 'Parameter.Value' --output text)

# Use $${} to escape Terraform template syntax
echo "Downloading WAR from s3://$${WAR_BUCKET}/$${WAR_KEY}"
aws s3 cp "s3://$${WAR_BUCKET}/$${WAR_KEY}" /tmp/ROOT.war

# Stop Tomcat, deploy WAR
systemctl stop tomcat || true
rm -rf /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/ROOT.war
cp /tmp/ROOT.war /opt/tomcat/webapps/ROOT.war
chown tomcat:tomcat /opt/tomcat/webapps/ROOT.war
rm -f /tmp/ROOT.war

# Configure CloudWatch Agent
cat >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'CWEOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/tomcat/logs/catalina.out",
            "log_group_name": "/ng-java-app/tomcat",
            "log_stream_name": "{instance_id}-catalina"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "ng-java-app/app",
    "metrics_collected": {
      "cpu": { "measurement": [{ "name": "cpu_usage_idle", "unit": "Percent" }] },
      "mem": { "measurement": [{ "name": "mem_used_percent", "unit": "Percent" }] }
    }
  }
}
CWEOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json || true

systemctl start tomcat

sleep 20
systemctl is-active --quiet tomcat && echo "Tomcat OK" || echo "Tomcat FAILED"

echo "=== App server user-data completed: $(date) ==="