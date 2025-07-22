# AWS Chartmuseum Infrastructure

This repository contains Terraform configurations for deploying Chartmuseum on AWS infrastructure. It provides a complete setup for hosting Helm chart repositories with S3 backend storage and automated deployment.

## 🏗️ Infrastructure Overview

This Terraform project manages:

- **AWS VPC & Networking**: Custom VPC with public subnet and internet gateway
- **EC2 Instance**: ARM64 instance running Chartmuseum container
- **S3 Storage**: Backend storage for Helm charts
- **Security Groups**: Network security configuration for Chartmuseum access
- **Automated Deployment**: User data script for container deployment

## 📁 Project Structure

```
terraform-chartmuseum/
├── main.tf                 # Chartmuseum infrastructure configuration
├── providers.tf            # AWS provider configuration
├── backend.tf              # Terraform backend configuration
├── variables.tf            # Input variables
└── outputs.tf              # Output values
```

## 🚀 Features

### Chartmuseum Deployment
- **Containerized Deployment**: Chartmuseum running in Docker container
- **S3 Backend Storage**: Helm charts stored in AWS S3 bucket
- **Public Access**: Chartmuseum accessible via HTTP on port 80
- **Auto-restart**: Container configured with restart policy

### Infrastructure Components
- **VPC & Subnet**: Isolated network environment
- **Security Groups**: Controlled access to Chartmuseum ports (80, 8080, 22)
- **S3 Bucket**: Dedicated storage for Helm charts
- **EC2 Instance**: ARM64 instance optimized for cost and performance

### Automation
- **User Data Script**: Automated installation and deployment
- **Docker Integration**: Automatic Docker installation and container management
- **Service Persistence**: Container configured to restart automatically

## 🔧 Prerequisites

- **Terraform** >= 1.0
- **AWS CLI** configured with appropriate credentials
- **AWS S3 Backend**: Configured S3 bucket for Terraform state storage

## 📋 Requirements

### AWS Requirements
- AWS account with appropriate permissions for:
  - EC2 instance creation and management
  - VPC and networking resources
  - S3 bucket creation and access
  - IAM roles and policies for EC2 operations

### Terraform Providers
- `hashicorp/aws` ~> 5.0 - AWS provider

## 🚀 Quick Start

### 1. Configure AWS Credentials
Set your AWS credentials as environment variables or configure AWS CLI:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Review the Plan
```bash
terraform plan
```

### 4. Apply the Configuration
```bash
terraform apply
```

### 5. Access Chartmuseum
After successful deployment, you can access Chartmuseum:
```bash
terraform output chartmuseum_url
```

## 🔐 Security Considerations

### Network Security
- **Public Access**: Chartmuseum accessible on port 80
- **SSH Access**: Port 22 open for instance management
- **Security Groups**: Controlled ingress and egress traffic
- **VPC Isolation**: Resources deployed in custom VPC

### Production Security Recommendations

1. **Private Subnet**: Consider deploying in private subnet with NAT gateway
2. **HTTPS**: Implement SSL/TLS termination for secure access
3. **Access Control**: Restrict security group rules to specific IP ranges
4. **IAM Roles**: Use IAM instance profiles instead of access keys
5. **Monitoring**: Implement CloudWatch monitoring and logging

## 🔄 Infrastructure Components

### VPC Configuration
- **CIDR Block**: 10.1.0.0/16
- **Public Subnet**: 10.1.1.0/24
- **Internet Gateway**: For public internet access
- **Route Table**: Routes traffic to internet gateway

### EC2 Instance
- **Instance Type**: t4g.small (ARM64)
- **AMI**: Amazon Linux 2 ARM64
- **Storage**: Default EBS storage
- **User Data**: Automated deployment script

### S3 Storage
- **Bucket Name**: unir-tfm-chartmuseum-bucket
- **Purpose**: Helm chart storage backend
- **Region**: us-east-1

## 📊 Outputs

The infrastructure provides the following outputs:

| Output | Description |
|--------|-------------|
| `instance_public_ip` | The public IP address of the EC2 instance |
| `chartmuseum_url` | The URL to access Chartmuseum |

## 🧹 Cleanup

To destroy all resources:
```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all infrastructure including the S3 bucket and its contents.

## 🔧 Customization

### Instance Configuration
Modify `main.tf` to adjust:
- Instance type for different performance requirements
- Security group rules for network access
- User data script for custom deployment logic

### Storage Configuration
Modify the S3 bucket configuration in `main.tf` to adjust:
- Bucket name and region
- Storage class and lifecycle policies
- Access permissions and encryption

### Network Configuration
Modify VPC and subnet settings in `main.tf` to adjust:
- CIDR blocks for different network ranges
- Subnet configuration for different availability zones
- Security group rules for access control

## 📝 Notes

- **State Management**: Uses S3 backend for remote state storage
- **Region**: Configured for us-east-1 region
- **Instance Type**: ARM64 instance for cost optimization
- **Container Port**: Chartmuseum runs on port 8080, mapped to host port 80
- **Storage Backend**: S3 storage configured for Helm chart persistence

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
