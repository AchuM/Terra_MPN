resource "aws_instance" "MPN" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name = "$Key_name"

  tags {
    Name = "MPN"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("${var.ssh_key_private}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt-get install python libselinux-python",
      "sudo apt-get install ansible",
    ]
  }


  provisioner "local-exec" {
    command = "ansible-playbook -i inventory playbooks/vagrant.yml --limit ${self.public_ip} --extra-vars 'ip=${self.public_ip}'}"
  }
}
