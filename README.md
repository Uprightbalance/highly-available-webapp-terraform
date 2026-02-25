# ha-webapp-terraform
# Highly Available Web Application on AWS (Terraform)

This project delivers a **highly available web application environment on AWS** using Terraform.  
The goal is to demonstrate practical AWS fundamentals like networking, load balancing, auto scaling, security best practices, and Infrastructure as Code (IaC).

---

## 🏗 Architecture Overview

The infrastructure consists of:

- Custom VPC (`10.0.0.0/16`)
- Public and private subnets across two Availability Zones (us-east-1a & us-east-1b)
- Internet Gateway for public access
- NAT Gateway for outbound internet access from private subnets
- **Public and Private Route Tables**
- Public route table routes Internet-bound traffic (0.0.0.0/0) to the Internet Gateway
- Private route table routes outbound traffic (0.0.0.0/0) to the NAT Gateway
- Public subnets are associated with the public route table and private subnets are associated with the Private route table
- Application Load Balancer (ALB)
- EC2 Auto Scaling Group running in private subnets
- Launch Template with EC2 user data
- IAM role and instance profile for EC2
- Apache web server serving a static page pulled from GitHub
- ALB health checks for traffic routing and fault tolerance
---

## 🔐 Security Design

This setup follows common AWS security best practices:

- Only the Application Load Balancer is exposed to the internet (HTTP :80)
- EC2 instances do not have public IP addresses
- Traffic to EC2 instances is restricted to the ALB security group
- IAM roles are used instead of static credentials
- Private subnets access the internet only through a NAT Gateway

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
- Terraform
- AWS CLI configured

### Steps
- terraform init
- terraform plan
- terraform apply

