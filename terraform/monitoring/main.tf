locals {
  ssh_keys = ["${split(",", var.ssh_key_ids)}"]
}

# Provision --single digital ocean-- droplet
resource "digitalocean_droplet" "gadgets" {
  image      = "${var.droplet_image}"
  name       = "${var.service_name}"
  region     = "${var.droplet_region}"
  size       = "${var.droplet_size}"
  monitoring = "${var.enable_monitoring}"
  ssh_keys   = "${local.ssh_keys}"
  tags       = ["${var.service_name}"]
  user_data  = "${data.template_file.ignition.rendered}"

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      # Add ssh user
      "sudo adduser --disabled-password --gecos '' ${var.ssh_username}",

      "sudo usermod -aG sudo ${var.ssh_username}",
      "sudo echo '${var.ssh_username} ALL=(ALL:ALL) ALL' >> /etc/sudoers",
      "sudo systemctl reload sshd",

      # Add user ssh key
      "mkdir /home/${var.ssh_username}/.ssh && touch /home/${var.ssh_username}/.ssh/authorized_keys",

      "chmod 0600 /home/${var.ssh_username}/.ssh/authorized_keys",

      # Updating repositories and installing base packages
      "sudo apt update",

      "sudo apt -y install apt-transport-https ca-certificates curl software-properties-common vim",

      # Install docker
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",

      "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      "apt -y install docker-ce",
      "apt -y install docker-compose",

      # Add users to the docker root group
      "usermod -aG docker root",

      "usermod -aG docker ${var.ssh_username}",

      # Configure grafana + prometheus monitoring
      "git clone https://github.com/stefanprodan/dockprom",

      "cd dockprom",
      "ADMIN_USER=${var.grafana_user} ADMIN_PASSWORD=${var.grafana_password} docker-compose up -d",
    ]
  }
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
    username = "${var.ssh_username}"
  }
}
