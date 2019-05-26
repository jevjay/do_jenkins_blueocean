# Digital Ocean Token value
variable "do_token" {
  default = ""
}

# Service name deployed from this configuration(s)
variable "service_name" {
  default = "gadgets"
}

# SSH keys which should be used for node access
# Multiple ssh_key_id values need to be separated by comma sign
variable "ssh_key_ids" {
  default = ""
}

# Size of a droplet instance used for Jenkins
# Additional information:
# - https://www.digitalocean.com/pricing/
# - https://developers.digitalocean.com/documentation/v2/#list-all-sizes
variable "droplet_size" {
  default = "s-1vcpu-2gb"
}

# Region, where Jenkins droplet instance should be deployed
variable "droplet_region" {
  default = "AMS3"
}

# Image used for Jenkins droplet instance
variable "droplet_image" {
  default = "ubuntu-18-04-x64"
}

# Enable droplet instance monitoring, which comes at no cost
# Addtional information:
# - https://www.digitalocean.com/docs/monitoring/
variable "enable_monitoring" {
  default = true
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

# Default Ubuntu Droplet user
# Can be replaced by username used to SSH into the machine
variable "ssh_username" {
  default = ""
}

# Default Grafana username
# IMPORTANT: Use default value only during the development/debugging
variable "grafana_user" {
  default = "admin"
}

# Default Grafana password.
# IMPORTANT: Use default value only during the development/debugging
variable "grafana_password" {
  default = "admin"
}
