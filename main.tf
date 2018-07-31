resource "aws_instance" "MPN" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "MPN"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-add-repository ppa:ansible/ansible",
      "apt-get update",
      "apt-get install python libselinux-python",
      "apt-get install ansible",
    ]
  }

  connection {
    type        = "ssh"
    user        = "fedora"
    private_key = "${file(var.ssh_key_private)}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.ssh_key_private} playbooks/vagrant.yml"
  }
}
