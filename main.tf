variable "key_name" {}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

resource "aws_instance" "MPN" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.generated_key.key_name}"

  tags {
    Name = "MPN"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file(var.ssh_key_private)}"
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "apt-add-repository ppa:ansible/ansible",
      "apt-get update",
      "apt-get install python libselinux-python",
      "apt-get install ansible",
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.ssh_key_private} playbooks/vagrant.yml"
  }
}
