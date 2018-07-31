resource "aws_instance" "MPN" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "MPN"
  }

 provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible"
      "sudo apt-get update",
      "sudo apt-get install ansible"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.ssh_key_private} playbooks/vagrant.yml"
  }
}
