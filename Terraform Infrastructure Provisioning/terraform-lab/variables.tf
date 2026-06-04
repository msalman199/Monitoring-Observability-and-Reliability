# TODO: Define variable for volume name
variable "volume_name" {
  description = "Name of the Docker volume"
  type        = string
  default     = "app-data-volume"
}

# TODO: Define variable for web server port
variable "web_port" {
  # Set description, type, and default value
}

# TODO: Define variable for container restart policy
variable "restart_policy" {
  # Options: "no", "always", "on-failure", "unless-stopped"
}
