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

resource "digitalocean_firewall" "gadgets" {
  name = "fwl-gadgets"

  droplet_ids = ["${digitalocean_droplet.gadgets.id}"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

data "template_file" "ignition" {
  template = "${file("config/ignition.tpl")}"

  vars = {
    username = "${var.username}"
  }
}
