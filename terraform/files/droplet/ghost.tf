resource "digitalocean_project" "blog" {
  name        = "${var.domain_name}-ghost-blog"
  description = "A project to group all ${var.domain_name} Ghost blog resources."
  purpose     = "Website or Blog"
  environment = "Production"
  resources   = [digitalocean_droplet.blog.urn, digitalocean_domain.blog.urn]
}

data "digitalocean_image" "ghost" {
  name = "ghost-18-04"
}

resource "digitalocean_droplet" "blog" {
  image      = data.digitalocean_image.ghost.image
  name       = "${var.domain_name}-blog"
  region     = var.droplet_region
  size       = var.droplet_size
  backups    = var.enable_backups
  monitoring = var.enable_monitoring
  ssh_keys   = local.ssh_keys
  tags       = [var.service_name]
}

resource "digitalocean_domain" "blog" {
  name       = var.domain_name
  ip_address = digitalocean_droplet.blog.ipv4_address
}



