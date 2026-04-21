# Production-Style Highly Available Web Infrastructure on AWS with Terraform

## Project Summary

This project provisions a highly available web application environment on AWS using Terraform.

It's designed to demonstrate practical cloud infrastructure engineering concepts such as:

- multi-AZ networking
- public/private subnet architecture
- load-balanced traffic routing
- private compute placement
- Auto Scaling
- IAM-based access control
- Infrastructure as Code (IaC)

> Rather than focusing only on launching AWS resources, this project models a realistic baseline for hosting a resilient web workload using production-relevant design patterns.

---

## Objective

The goal of this project is to answer a foundational infrastructure question:

This implementation emphasizes:

- **availability**
- **network isolation**
- **automated provisioning**
- **scalable compute design**
- **secure public ingress patterns**

---

## Architecture Overview

The infrastructure consists of:

- A custom **VPC** (`10.0.0.0/16`)
- **Public and private subnets** across two Availability Zones
- An **Internet Gateway** for public ingress/egress
- A **NAT Gateway** for outbound internet access from private subnets
- Separate **public and private route tables**
- An **Application Load Balancer (ALB)**
- An **EC2 Auto Scaling Group**
- A **Launch Template** with instance bootstrap configuration
- **IAM role and instance profile** for EC2 access control
- An Apache web server serving application content
- ALB health checks for traffic routing and instance validation

---

## High-Level Design

### Traffic Flow

1. A user sends an HTTP request to the **Application Load Balancer**
2. The ALB forwards traffic to healthy EC2 instances in the target group
3. EC2 instances run inside **private subnets**
4. Instances serve the web application through Apache
5. Outbound internet access from private instances is provided through the **NAT Gateway**

> This design ensures the application remains publicly reachable while keeping the underlying compute layer private.

---

## Why This Architecture

This implementation intentionally follows a **security-first, high-availability-oriented AWS design** rather than placing web servers directly on the public internet.

### Core design choices include:

- **Public ALB, private EC2 instances**
- **Multi-AZ subnet distribution**
- **Auto Scaling-managed compute**
- **Route table separation**
- **IAM roles instead of static credentials**
- **Terraform-managed infrastructure**

> The result is a practical baseline that reflects common production hosting patterns for simple stateless web applications.

---

## Architectural Decisions and Tradeoffs

### 1. Private EC2 Instances Behind a Public ALB

**Decision:** Placed application instances in private subnets and exposed only the ALB publicly.

**Why:**
- Reduces direct attack surface
- Prevents public SSH/HTTP exposure to application servers
- Centralizes ingress through a controlled edge layer

**Tradeoff:**
- Requires more networking components and route configuration
- Depends on NAT for outbound internet access from private instances

---

### 2. Multi-AZ Deployment for Availability

**Decision:** Distribute subnets and instances across two Availability Zones.

**Why:**
- Reduces reliance on a single failure domain
- Improves service resilience if one zone experiences disruption
- Supports load-balanced traffic distribution across zones

**Tradeoff:**
- Increases infrastructure complexity
- Requires additional subnet, routing, and target registration considerations

> This aligns with a core AWS availability principle: infrastructure should tolerate the loss of an individual Availability Zone without complete service failure.

---

### 3. Auto Scaling Group for Compute Lifecycle Management

**Decision:** Used an Auto Scaling Group to manage EC2 instances.

**Why:**
- Enables self-healing instance replacement
- Supports distributed workload placement
- Treats instances as replaceable infrastructure rather than manually maintained servers

**Tradeoff:**
- Requires reliable launch configuration and bootstrap automation
- Adds dependency on Launch Template and health check behavior

---

### 4. NAT Gateway for Private Subnet Internet Access

**Decision:** Used a NAT Gateway to allow private instances to access the internet for package installation and application bootstrap.

**Why:**
- Enables private instances to retrieve updates and dependencies
- Preserves private subnet isolation while still allowing controlled outbound access

**Tradeoff:**
- Introduces additional cost
- Creates an egress dependency for private workloads

---

### 5. Single NAT Gateway as a Cost Optimization

**Decision:** Used one NAT Gateway rather than one per Availability Zone.

**Why:**
- Reduces cost for small-scale environment
- Keeps the architecture easier to manage 

**Tradeoff:**
- Outbound internet access is not fully highly available across AZs
- If the NAT Gateway’s AZ is impaired, private subnet egress may be affected

> This is a deliberate cost-vs-resilience tradeoff. A production-grade fully resilient design would typically deploy one NAT Gateway per Availability Zone.

---

### 6. Launch Template + User Data Bootstrap

**Decision:** Used Launch Template user data to install Apache, Git, and retrieve application content automatically.

**Why:**
- Keeps provisioning self-contained
- Eliminates the need for manual instance configuration
- Supports reproducible environment initialization

**Tradeoff:**
- Bootstrapping depends on runtime package installation and network availability
- Slower and less deterministic than pre-baked machine images

> For lightweight workloads, user data is practical and effective. For larger-scale systems, this would typically evolve toward immutable AMIs or image-based deployment workflows.

---

## Security Design

This setup follows several baseline AWS security best practices:

- Only the **Application Load Balancer** is publicly exposed
- EC2 instances **do not receive public IP addresses**
- Application traffic to EC2 instances is restricted to the **ALB security group**
- IAM roles are used instead of static credentials
- Private subnets access the internet only through the **NAT Gateway**

### Security Outcome

This design ensures the web tier remains reachable while the underlying application hosts are not directly exposed to the public internet.

---

## Automation Details

Application provisioning is automated through infrastructure and instance bootstrap configuration.

### Automated behaviors include:

- EC2 instances are launched via a **Launch Template**
- Apache and Git are installed through **user data**
- Web content is pulled automatically from:

```text
https://github.com/Uprightbalance/jobapp-index.git
```

```md
## Related Repositories

- **Web content Repository**  
Web content is pulled automatically for this repository.
https://github.com/Uprightbalance/jobapp-index.git
```
