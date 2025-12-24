# Setup Instructions

## Prerequisites

1. Yandex Cloud account with appropriate permissions
2. Service account with required roles
3. Terraform v1.0+ installed
4. YC CLI configured

## Step-by-Step Setup

### 1. Configure Variables

```bash
# Create terraform.tfvars from example
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
2. Add Service Account Key
Download key.json from Yandex Cloud Console and place it in the project root.

3. Initialize Terraform
bash
terraform init
4. Deploy Infrastructure
bash
terraform apply -auto-approve
5. Configure Kubernetes Access
bash
yc managed-kubernetes cluster get-credentials your-cluster-name --external
kubectl get nodes
Output Values
After deployment, use these commands:

bash
# Get all outputs
terraform output

# Get specific values
terraform output cluster_endpoint
terraform output postgres_fqdn
terraform output clickhouse_fqdn
Maintenance
bash
# Check infrastructure status
terraform state list

# Update infrastructure
terraform plan
terraform apply

# Destroy everything
terraform destroy
Troubleshooting
Error: Invalid credentials - Check key.json and service account permissions

Error: Network not found - Verify network_name in terraform.tfvars

Error: Quota exceeded - Check resource limits in Yandex Cloud
