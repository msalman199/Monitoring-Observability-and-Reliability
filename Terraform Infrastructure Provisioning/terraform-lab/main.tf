# TODO: Configure the Terraform required version and providers block
terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# TODO: Initialize the Docker provider
provider "docker" {
  # Provider connects to local Docker daemon
}
# TODO: Create a Docker network resource
resource "docker_network" "app_network" {
  name = "terraform-network"
  # Add driver configuration
}

# TODO: Define a Docker volume for persistent storage
resource "docker_volume" "app_data" {
  # Configure volume name using variable
}

# TODO: Create a Docker container resource for Nginx
resource "docker_container" "web_server" {
  # Configure image, name, and ports
  # Attach to network and volume
  # Set restart policy
}

# TODO: Create a second container for a simple application
resource "docker_container" "app_server" {
  # Use a different image (e.g., httpd, redis)
  # Configure networking and dependencies
}
terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

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


