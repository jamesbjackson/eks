#/bin/bash

set -uo pipefail

STACK_NAME=${1:?"No cloudformation stack specified"}
AWS_REGION=${2:?"No AWS region specified"}

CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $AWS_REGION --query "Stacks[0].Outputs[?OutputKey=='ClusterName'].OutputValue" --output text)
WORKER_NODE_IAM_ROLE_ARN=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $AWS_REGION --query "Stacks[0].Outputs[?OutputKey=='WorkerNodeIamRoleArn'].OutputValue" --output text)

(
cat > terraform.tfvars << EOF
cluster_name = "$CLUSTER_NAME"
worker_node_iam_role_arn = "$WORKER_NODE_IAM_ROLE_ARN"
EOF
)

aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

terraform init
terraform apply
