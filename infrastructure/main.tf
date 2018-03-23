# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create swarm manager
resource "digitalocean_droplet" "manager" {
  image = "ubuntu-16-04-x64"
  name = "manager"
  region = "nyc1"
  size = "4gb"
  ssh_keys = [18911138]
  connection {
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "remote-exec" {
    inline = [
      "wget -O - https://raw.githubusercontent.com/rancher/install-docker/master/17.12.1.sh | bash",
      "docker swarm init --advertise-addr ${self.ipv4_address}"
    ]
  }
}

resource "digitalocean_droplet" "worker_fra" {
  count = 10
  image = "ubuntu-16-04-x64"
  name = "worker"
  region = "fra1"
  size = "1gb"
  ssh_keys = [18911138]
  connection {
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "remote-exec" {
    inline = [
      "wget -O - https://raw.githubusercontent.com/rancher/install-docker/master/17.12.1.sh | bash",
      "docker swarm join --token ${data.external.worker_token.result.worker} ${digitalocean_droplet.manager.ipv4_address}"
    ]
  }
}

resource "digitalocean_droplet" "worker_nyc" {
  count = 10
  image = "ubuntu-16-04-x64"
  name = "worker"
  region = "nyc1"
  size = "1gb"
  ssh_keys = [18911138]
  connection {
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "remote-exec" {
    inline = [
      "wget -O - https://raw.githubusercontent.com/rancher/install-docker/master/17.12.1.sh | bash",
      "docker swarm join --token ${data.external.worker_token.result.worker} ${digitalocean_droplet.manager.ipv4_address}"
    ]
  }
}

data "external" "worker_token" {
  program = ["./fetch-tokens.sh"]
  query = {
    host = "${digitalocean_droplet.manager.ipv4_address}"
  }
  depends_on = ["digitalocean_droplet.manager"]
}

output "manager_ip" {
  value = "${digitalocean_droplet.manager.ipv4_address}"
}