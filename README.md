# Yandex Cloud Infrastructure as Code

Production-ready Terraform configuration for deploying complete infrastructure stack in Yandex Cloud.

## 🚀 Quick Start

1. Clone repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Add `key.json` service account key
4. Run `terraform init`
5. Run `terraform apply`

## 📦 Deployed Resources

- **Kubernetes Cluster** (2 nodes, v1.30)
- **PostgreSQL** (v15, 20GB SSD)
- **ClickHouse** with `analytics` database
- **Redis** (7.2-valkey, 16GB SSD)
- **Container Registry**
- **VPC Network & Subnet**

## 🔒 Security Notes

- Never commit `terraform.tfvars` or `key.json` to git
- Use `.gitignore` to protect sensitive files
- Store Terraform state remotely

## �� Project Structure
├── main.tf # Main configuration
├── variables.tf # Variable definitions
├── terraform.tfvars.example # Safe variable template
├── README.md # This documentation
└── .gitignore # Protected files list

text

## 📞 Support

For issues and questions, please check the SETUP.md file.
