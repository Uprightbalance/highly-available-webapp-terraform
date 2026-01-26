# Highly Available Web Application on AWS (Terraform)

This project provisions a **highly available, fault-tolerant web application architecture on AWS** using Terraform.

It demonstrates core AWS infrastructure concepts including VPC design, Auto Scaling, Load Balancing, IAM, and Infrastructure as Code (IaC).

---

## 🏗 Architecture Overview

- Custom VPC (10.0.0.0/16)
- Multi-AZ public and private subnets
- Internet Gateway & NAT Gateway
- Application Load Balancer (ALB)
- EC2 Auto Scaling Group (private subnets)
- Launch Template with user data
- IAM Role & Instance Profile
- Apache web server serving content from GitHub
- Health checks via ALB

---

## 🔐 Security Design

- ALB exposed to the internet (HTTP :80)
- EC2 instances are **not publicly accessible**
- ALB → EC2 traffic controlled via security groups
- IAM role attached to EC2 for secure AWS access
- Private subnets use NAT Gateway for outbound access only

---

## ⚙️ Automation Details

- EC2 instances are launched via a Launch Template
- User data installs Apache and Git
- Web content is pulled automatically from:
  https://github.com/Uprightbalance/jobapp-index.git
- Auto Scaling Group maintains desired capacity across AZs
- ALB health checks ensure traffic is only sent to healthy instances

---

## 🚀 How to Deploy

### Prerequisites
- AWS account
- Terraform v1.5+
- AWS CLI configured

### Steps
terraform init
terraform plan
terraform apply

