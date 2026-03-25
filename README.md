# terraform-aws-secure-vpc
Project: Production-Grade Secure VPC (Terraform)
Perfect—this is exactly the kind of **portfolio-grade project** that can push you into **Cloud Architect / Security Engineer roles** 🚀

I’ll give you a **production-ready Terraform VPC project** with:

* Modular design (real enterprise style)
* Secure architecture (private subnets, NAT, no public backend)
* Ready for AWS deployment
* GitHub-quality structure

---

# 🚀 🎯 Project: Production-Grade Secure VPC (Terraform)

---

# 🧠 Architecture Overview

![Image](https://stratus10.com/sites/default/files/inline-images/3-tier%20infrastructure-complete_0.png)

![Image](https://miro.medium.com/1%2AcTnA9qFAIveeZa4LafFTsA.png)

![Image](https://miro.medium.com/1%2ANg3kWlSQqIk5rECJb26YPA.png)

![Image](https://miro.medium.com/1%2AIZS7qCHR6TDPG8jGweVQjw.jpeg)

### What you are building:

✅ VPC with CIDR `10.0.0.0/16`
✅ 2 Public Subnets (ALB + NAT)
✅ 2 Private Subnets (App layer)
✅ Internet Gateway
✅ NAT Gateway
✅ Route Tables
✅ Security Groups

---

# 📂 Project Structure (Enterprise Level)

```bash
terraform-aws-secure-vpc/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── subnets/
│   ├── igw/
│   ├── nat/
│   ├── route_tables/
│   └── security_groups/
│
└── README.md
```

---

# ⚙️ 1. Root main.tf

```hcl
provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.project_name
}

module "subnets" {
  source = "./modules/subnets"

  vpc_id = module.vpc.vpc_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source = "./modules/nat"

  public_subnet_id = module.subnets.public_subnet_ids[0]
}

module "route_tables" {
  source = "./modules/route_tables"

  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  nat_gateway_id    = module.nat.nat_id
  public_subnets    = module.subnets.public_subnet_ids
  private_subnets   = module.subnets.private_subnet_ids
}
```

---

# 📥 2. variables.tf

```hcl
variable "region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "secure-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}
```

---

# 🌐 3. modules/vpc/main.tf

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}
```

---

# 🌍 4. modules/subnets/main.tf

```hcl
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id     = var.vpc_id
  cidr_block = var.public_subnets[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id     = var.vpc_id
  cidr_block = var.private_subnets[count.index]

  tags = {
    Name = "private-${count.index}"
  }
}
```

---

# 🌐 5. modules/igw/main.tf

```hcl
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
}
```

---

# 🌍 6. modules/nat/main.tf

```hcl
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id
}
```

---

# 🛣️ 7. modules/route_tables/main.tf

```hcl
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_assoc" {
  count = length(var.public_subnets)

  subnet_id      = var.public_subnets[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = var.nat_gateway_id
  destination_cidr_block = "0.0.0.0/0"
}
```

---

# 🔐 8. Security Group (IMPORTANT)

```hcl
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

# ▶️ 9. terraform.tfvars

```hcl
region = "ap-south-1"
project_name = "prod-secure-vpc"
```

---

# 🚀 10. How to Run

```bash
terraform init
terraform plan
terraform apply
```

---

# 🧪 What You Should Test

After deployment:

✅ EC2 in public subnet → internet access
✅ EC2 in private subnet → via NAT
✅ No direct public access to private EC2

---

# 🔥 Advanced Upgrades (MUST for You)

---

## ⭐ Add ALB + Auto Scaling

* Public ALB
* Private EC2

---

## ⭐ Add VPC Endpoints (Security Boost)

* S3 without internet

---

## ⭐ Add Flow Logs

* Traffic monitoring

---

## ⭐ Add Bastion Host

* Controlled SSH access

---

## ⭐ Multi-AZ NAT (Production Level)

* High availability

---

# 💼 Interview Impact

If you build & explain this:

👉 You can crack:

* AWS Architect roles
* Cloud Security Engineer
* DevOps Lead

---

# 🚀 Next Step (Highly Recommended)

I can upgrade this into:

👉 **Enterprise Terraform (like real companies)**

* Remote backend (S3 + DynamoDB lock)
* CI/CD (GitHub Actions)
* Multi-account setup
* Reusable modules

OR

👉 **Hands-on lab with EC2 + ALB + RDS**

---

Just tell me:

👉 “Upgrade to enterprise Terraform”
👉 “Add ALB + autoscaling + RDS”
👉 “Create real interview scenario questions”

I’ll take you to **architect level mastery** 🔥
