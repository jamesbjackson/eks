
# Creating Rancher KOPS Cluster

In order to the create this cluster you need to preform the following steps.

1. Create S3 Bucket to manage the Kubernetes cluster state.
```
stack_master apply london rancher-kops-s3-bucket --yes
```

2. Then export the S3 Bucket name so can be used by KOPS. 
```
export KOPS_STATE_STORE=s3://cpio-kops-rauncher
export KOPS_CLUSTER_NAME=kops-rancher.connectedproducts.io
```

3. We then configure the cluster
```
kops create cluster --cloud aws  --zones eu-west-2a --topology public --networking weave --node-size t3.medium --master-size t3.medium  --node-count 1 $KOPS_CLUSTER_NAME
```

4. We the apply the configuration to the cluster with auto approval.
```
kops update cluster --name $KOPS_CLUSTER_NAME --yes
kops rolling-update cluster
```

Security Group for Application Load Balancer Controller Ingress
To be able to route traffic from ALB to your nodes you need to create an Amazon EC2 security group with Kubernetes tags, that allow ingress port 80 and 443 from the internet and everything from ALBs to your nodes. You also need to allow traffic to leave the ALB to the Internet and Kubernetes nodes. Tags are used from Kubernetes components to find AWS components owned by the cluster. We will do with the AWS cli:

See https://github.com/kubernetes/kops/tree/master/addons/kube-ingress-aws-controller

```
VPC_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=nodes.$KOPS_CLUSTER_NAME | jq '.["SecurityGroups"][0].VpcId' -r)
aws ec2 create-security-group --description ingress.$KOPS_CLUSTER_NAME --group-name ingress.$KOPS_CLUSTER_NAME --vpc-id $VPC_ID
aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=ingress.$KOPS_CLUSTER_NAME
sgidingress=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=ingress.$KOPS_CLUSTER_NAME | jq '.["SecurityGroups"][0]["GroupId"]' -r)
sgidnode=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=nodes.$KOPS_CLUSTER_NAME | jq '.["SecurityGroups"][0]["GroupId"]' -r)
aws ec2 authorize-security-group-ingress --group-id $sgidingress --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $sgidingress --protocol tcp --port 80 --cidr 0.0.0.0/0
#aws ec2 authorize-security-group-egress --group-id $sgidingress --protocol all --port -1 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $sgidnode --protocol all --port -1 --source-group $sgidingress
aws ec2 create-tags --resources $sgidingress --tags Key="kubernetes.io/cluster/${KOPS_CLUSTER_NAME}",Value="owned" Key="kubernetes:application",Value="kube-ingress-aws-controller"
```



5. Setting up terraform configuration
```
go get -u github.com/banzaicloud/terraform-provider-k8s
export GOPATH=~/go
cd terraform/rancher
