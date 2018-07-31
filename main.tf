resource "aws_instance" "MPN" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "MPN"
  }

  provisioner "local-exec" {
    command = "sleep 120; ansible-playbook -i /usr/local/bin/terraform-inventory -u ubuntu playbooks/vagrant.yml --private-key=/home/user/.ssh/aws_user.pem -u ubuntu"
  }
}
