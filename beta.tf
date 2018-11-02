variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "user_password" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "holmescode" {
  image              = "ubuntu-18-04-x64"
  region             = "sfo2"
  name               = "beta.holmescode.com"
  size               = "s-2vcpu-2gb"
  private_networking = false

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  provisioner "file" {
    source      = "./provision.sh"
    destination = "/tmp/provision.sh"

    connection {
      user    = "root"
      type    = "ssh"
      agent   = true
      timeout = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh ${var.user_password}",
      "rm -f /tmp/provision.sh",
    ]

    connection {
      user    = "root"
      type    = "ssh"
      agent   = true
      timeout = "2m"
    }
  }
}

output "ip" {
  value = "${digitalocean_droplet.holmescode.ipv4_address}"
}
