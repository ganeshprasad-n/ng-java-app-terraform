#!/bin/bash
set -e
exec > >(tee /var/log/backend-user-data.log) 2>&1

echo "=== Backend User Data: $(date) ==="

REGION="us-east-1"

sleep 10

# Get RabbitMQ credentials from SSM
RABBITMQ_USER=$(aws ssm get-parameter --name "/ng-java-app/rabbitmq/username" --region "$REGION" --query 'Parameter.Value' --output text)
RABBITMQ_PASS=$(aws ssm get-parameter --name "/ng-java-app/rabbitmq/password" --region "$REGION" --with-decryption --query 'Parameter.Value' --output text)

echo "Starting backend services..."

systemctl start rabbitmq-server || true
sleep 15
systemctl start elasticsearch || true
sleep 20

# Configure RabbitMQ user
if /opt/rabbitmq/sbin/rabbitmqctl list_users | grep -q "$RABBITMQ_USER"; then
  echo "RabbitMQ user $${RABBITMQ_USER} already exists"
else
  /opt/rabbitmq/sbin/rabbitmqctl add_user "$RABBITMQ_USER" "$RABBITMQ_PASS" || true
fi

/opt/rabbitmq/sbin/rabbitmqctl set_user_tags "$RABBITMQ_USER" administrator || true
/opt/rabbitmq/sbin/rabbitmqctl set_permissions -p / "$RABBITMQ_USER" ".*" ".*" ".*" || true
/opt/rabbitmq/sbin/rabbitmqctl delete_user guest 2>/dev/null || true

# CloudWatch Agent config
cat >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/rabbitmq/rabbit@*.log",
            "log_group_name": "/ng-java-app/rabbitmq",
            "log_stream_name": "{instance_id}-rabbitmq"
          },
          {
            "file_path": "/var/log/elasticsearch/*.log",
            "log_group_name": "/ng-java-app/elasticsearch",
            "log_stream_name": "{instance_id}-elasticsearch"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "ng-java-app/backend",
    "metrics_collected": {
      "cpu": { "measurement": [{ "name": "cpu_usage_idle", "unit": "Percent" }] },
      "mem": { "measurement": [{ "name": "mem_used_percent", "unit": "Percent" }] }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json || true

echo "Service status:"
systemctl is-active --quiet rabbitmq-server && echo "RabbitMQ OK" || echo "RabbitMQ FAILED"
systemctl is-active --quiet elasticsearch && echo "Elasticsearch OK" || echo "Elasticsearch FAILED"

echo "=== Backend user-data completed: $(date) ==="