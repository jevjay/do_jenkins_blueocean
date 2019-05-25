# Provision --single digital ocean-- droplet
resource "digitalocean_droplet" "gadgets" {
  image      = "${var.droplet_image}"
  name       = "${var.service_name}"
  region     = "${var.droplet_region}"
  size       = "${var.droplet_size}"
  monitoring = "${var.enable_monitoring}"
  ssh_keys   = "${var.ssh_keys}"
  tags       = ["${var.service_name}"]
  user_data  = "${data.template_file.ignition.rendered}"
}

data "template_file" "ignition" {
  template = "${file("config/ignition.tpl")}"

  vars = {
    username = "${var.username}"
  }
}
