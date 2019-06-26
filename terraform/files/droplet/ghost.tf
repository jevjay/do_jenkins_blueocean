data "digitalocean_image" "ghost" {
  name = "ghost-18-04"
}

resource "digitalocean_droplet" "ghost" {
  image  = "${data.digitalocean_image.example1.image}"
  name   = "beardedgamedev-blog"
  region = "${var.droplet_region}"
  size   = "${var.droplet_size}"
}