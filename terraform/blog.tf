module "blog" {
    source = "./blog"
    ssh_key_id = var.ssh_key_id
    domain_name = var.domain_name
}