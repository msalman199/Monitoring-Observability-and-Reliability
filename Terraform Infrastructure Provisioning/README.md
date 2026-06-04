# 🚀 Terraform Infrastructure Provisioning 

<p align="center">

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![HCL](https://img.shields.io/badge/HCL-Configuration-blueviolet?style=for-the-badge)
![DevOps](https://img.shields.io/badge/DevOps-Automation-success?style=for-the-badge)

</p>

---

# 📖 Terraform Infrastructure Provisioning

## 🎯 Overview

Terraform is an Infrastructure as Code (IaC) tool that enables you to define, provision, manage, and destroy infrastructure using declarative configuration files.

In this lab, you will install Terraform, configure providers, create Docker infrastructure, manage state files, and learn the complete Terraform workflow from provisioning to destruction.

---

# 📋 Prerequisites

Before starting this lab, ensure you have:

✅ Basic Linux command-line knowledge

✅ Familiarity with YAML/JSON syntax

✅ Understanding of infrastructure concepts

✅ Basic text editor skills (vim, nano, VS Code)

---

# 🎯 Learning Objectives

By the end of this lab, you will be able to:

✅ Install and configure Terraform

✅ Write Terraform configuration files using HCL

✅ Provision local infrastructure using Docker Provider

✅ Apply and manage Terraform state

✅ Destroy infrastructure safely

---

# 🛠️ Environment Setup

---

## 🔹 Step 1: Start Lab Environment

1. Click **Start Lab**
2. Wait 2–3 minutes for provisioning
3. Connect using provided SSH credentials

Verify access:

```bash
hostname

whoami
```

---

## 🔹 Step 2: Install Terraform

Update package repository:

```bash
sudo apt update
```

Install dependencies:

```bash
sudo apt install -y wget unzip
```

Download Terraform:

```bash
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
```

Extract package:

```bash
unzip terraform_1.6.6_linux_amd64.zip
```

Install binary:

```bash
sudo mv terraform /usr/local/bin/
```

Verify installation:

```bash
terraform version
```

Expected Output:

```text
Terraform v1.6.6
```

---

## 🔹 Step 3: Install Docker

Install Docker:

```bash
sudo apt install -y docker.io
```

Start service:

```bash
sudo systemctl start docker

sudo systemctl enable docker
```

Add user to Docker group:

```bash
sudo usermod -aG docker $USER
```

Apply group changes:

```bash
newgrp docker
```

Verify:

```bash
docker --version
```

Expected:

```text
Docker version xx.x.x
```

---

# 🧪 Task 1: Write Terraform Configuration

---

## 🔹 Step 1: Create Project Directory

```bash
mkdir -p ~/terraform-lab

cd ~/terraform-lab
```

Create configuration files:

```bash
touch main.tf variables.tf outputs.tf
```

Verify:

```bash
ls -la
```

Expected:

```text
main.tf
variables.tf
outputs.tf
```

---

## 🔹 Step 2: Configure Terraform Provider

Edit:

```bash
nano main.tf
```

Add:

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
}
```

---

## 🔹 Step 3: Define Infrastructure Resources

Add:

```hcl
resource "docker_network" "app_network" {
  name   = "terraform-network"
  driver = "bridge"
}

resource "docker_volume" "app_data" {
  name = var.volume_name
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "web_server" {
  name  = "terraform-nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.web_port
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.app_data.name
    container_path = "/usr/share/nginx/html"
  }

  restart = var.restart_policy
}
```

---

## 🔹 Step 4: Create Second Container

Add:

```hcl
resource "docker_image" "redis" {
  name = "redis:latest"
}

resource "docker_container" "app_server" {
  name  = "terraform-redis"
  image = docker_image.redis.image_id

  restart = var.restart_policy

  networks_advanced {
    name = docker_network.app_network.name
  }
}
```

---

## 🔹 Step 5: Define Variables

Edit:

```bash
nano variables.tf
```

Add:

```hcl
variable "volume_name" {
  description = "Name of Docker volume"
  type        = string
  default     = "app-data-volume"
}

variable "web_port" {
  description = "Port exposed for Nginx"
  type        = number
  default     = 8080
}

variable "restart_policy" {
  description = "Container restart policy"
  type        = string
  default     = "unless-stopped"
}
```

---

## 🔹 Step 6: Define Outputs

Edit:

```bash
nano outputs.tf
```

Add:

```hcl
output "web_container_id" {
  value = docker_container.web_server.id
}

output "network_name" {
  value = docker_network.app_network.name
}

output "web_url" {
  value = "http://localhost:${var.web_port}"
}
```

---

# 🚀 Task 2: Apply Terraform Plan

---

## 🔹 Step 1: Initialize Terraform

Initialize project:

```bash
terraform init
```

Expected:

```text
Terraform has been successfully initialized!
```

What happens?

✅ Downloads providers

✅ Creates .terraform directory

✅ Initializes state backend

---

## 🔹 Step 2: Validate Configuration

Validate syntax:

```bash
terraform validate
```

Format files:

```bash
terraform fmt
```

Verify:

```bash
cat main.tf
```

Expected:

```text
Success! The configuration is valid.
```

---

## 🔹 Step 3: Create Execution Plan

Generate plan:

```bash
terraform plan
```

Save plan:

```bash
terraform plan -out=tfplan
```

View plan:

```bash
terraform show tfplan
```

Review:

🟢 Resources to Create (+)

🟡 Resources to Modify (~)

🔴 Resources to Destroy (-)

---

## 🔹 Step 4: Apply Configuration

Apply plan:

```bash
terraform apply
```

Or:

```bash
terraform apply tfplan
```

Type:

```text
yes
```

Monitor:

- Network creation
- Volume creation
- Image downloads
- Container startup

Expected:

```text
Apply complete!
```

---

## 🔹 Step 5: Verify Infrastructure

Check Terraform state:

```bash
terraform state list
```

View resource:

```bash
terraform state show docker_container.web_server
```

Verify Docker:

```bash
docker ps

docker network ls

docker volume ls
```

Test web server:

```bash
curl http://localhost:8080
```

Expected:

```html
Welcome to nginx!
```

---

## 🔹 Step 6: Inspect Outputs

Display outputs:

```bash
terraform output
```

Specific output:

```bash
terraform output web_url
```

JSON output:

```bash
terraform output -json
```

Example:

```text
web_url = http://localhost:8080
```

---

## 🔹 Step 7: Modify Infrastructure

Create:

```bash
nano terraform.tfvars
```

Add:

```hcl
volume_name    = "my-custom-volume"
web_port       = 8080
restart_policy = "unless-stopped"
```

Plan:

```bash
terraform plan -var-file="terraform.tfvars"
```

Apply:

```bash
terraform apply -var-file="terraform.tfvars"
```

---

## 🔹 Step 8: Manage State

List resources:

```bash
terraform state list
```

Check state file:

```bash
ls -la terraform.tfstate
```

View state:

```bash
terraform show
```

Refresh:

```bash
terraform refresh
```

---

## 🔹 Step 9: Destroy Infrastructure

Preview destruction:

```bash
terraform plan -destroy
```

Destroy:

```bash
terraform destroy
```

Confirm:

```text
yes
```

Verify cleanup:

```bash
docker ps -a

docker network ls

docker volume ls
```

---

# 📊 Verification Checklist

---

## Configuration Verification

- [x] Terraform 1.6.x Installed
- [x] Docker Running
- [x] Project Directory Created
- [x] HCL Files Configured
- [x] Terraform Validation Passed
- [x] Terraform Formatting Applied

---

## Infrastructure Verification

- [x] terraform init Successful
- [x] Plan Generated
- [x] Apply Completed
- [x] State File Created
- [x] Containers Running
- [x] Network Created
- [x] Volume Created
- [x] Web Server Accessible
- [x] Outputs Displayed
- [x] Destroy Completed

---

# 🔍 Verification Commands

Verify Terraform resources:

```bash
terraform state list | wc -l
```

Verify containers:

```bash
docker ps --filter "name=terraform" \
--format "{{.Names}}"
```

Inspect network:

```bash
docker network inspect terraform-network
```

Inspect volume:

```bash
docker volume inspect app-data-volume
```

Test application:

```bash
curl -I http://localhost:8080
```

Expected:

```text
HTTP/1.1 200 OK
```

---

# 🛠️ Troubleshooting

---

## ❌ Terraform Init Fails

Clear cache:

```bash
rm -rf .terraform

rm -f .terraform.lock.hcl
```

Retry:

```bash
terraform init
```

---

## ❌ Docker Permission Denied

Add user:

```bash
sudo usermod -aG docker $USER
```

Apply:

```bash
newgrp docker
```

---

## ❌ Port Already In Use

Check:

```bash
sudo netstat -tulpn | grep :8080
```

Change port:

```hcl
web_port = 9090
```

---

## ❌ State Lock Error

Remove lock:

```bash
rm -f .terraform.tfstate.lock.info
```

⚠️ Only if no Terraform process is running.

---

## ❌ Resource Already Exists

Import resource:

```bash
terraform import docker_container.web_server <container_id>
```

Or remove:

```bash
docker rm -f terraform-nginx
```

---

# 🧹 Cleanup

Remove infrastructure:

```bash
terraform destroy
```

Remove project:

```bash
cd ~

rm -rf ~/terraform-lab
```

Verify cleanup:

```bash
docker ps -a

docker network ls

docker volume ls
```

---

# 🎓 Conclusion

Congratulations! You have successfully completed the Terraform Infrastructure Provisioning Lab.

You learned how to:

✅ Install and configure Terraform

✅ Write HCL configuration files

✅ Configure Providers

✅ Create Docker infrastructure

✅ Use Variables and Outputs

✅ Manage Terraform State

✅ Apply Infrastructure Changes

✅ Destroy Resources Safely

---

# 💡 Key Concepts Learned

## Infrastructure as Code (IaC)

Infrastructure defined using code instead of manual configuration.

---

## Terraform Workflow

```text
terraform init
      ↓
terraform plan
      ↓
terraform apply
      ↓
terraform destroy
```

---

## State Management

Terraform tracks infrastructure using:

```text
terraform.tfstate
```

---

## Resource Dependencies

Terraform automatically determines:

```text
Networks → Volumes → Images → Containers
```

---

## Idempotency

Running:

```bash
terraform apply
```

multiple times produces the same desired state.

---

# 🌍 Real-World Applications

Terraform is widely used to:

✅ Provision AWS Infrastructure

✅ Deploy Azure Resources

✅ Manage Google Cloud Services

✅ Build Kubernetes Clusters

✅ Configure Networking & Security

✅ Enable Disaster Recovery

✅ Standardize Multi-Environment Deployments

---

# 🚀 Next Steps

### 🔹 Remote State Management

Explore:

- Terraform Cloud
- AWS S3 Backend
- Azure Storage Backend

---

### 🔹 Terraform Modules

Create reusable infrastructure components.

---

### 🔹 Cloud Providers

Practice with:

- AWS
- Azure
- GCP

---

### 🔹 CI/CD Integration

Automate Terraform using:

- GitHub Actions
- GitLab CI/CD
- Jenkins

---

### 🔹 Advanced Features

Learn:

- Workspaces
- Data Sources
- Provisioners
- Dynamic Blocks
- Lifecycle Rules

---

# 🏆 Lab Completed Successfully

```text
✔ Terraform Installed
✔ Docker Configured
✔ Provider Initialized
✔ Infrastructure Defined
✔ Plan Generated
✔ Resources Created
✔ State Managed
✔ Outputs Verified
✔ Infrastructure Destroyed
✔ Cleanup Completed
```

🎉 Congratulations! You now have foundational Terraform Infrastructure as Code (IaC) skills and can provision, manage, and automate infrastructure using Terraform.
