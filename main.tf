resource "aws_instance" "my-test-instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "MPN"
  }

  provisioner "local-exec" {
    command = "sleep 30 && echo -e \"[MPN]\n${aws_instance.MPN.ipv4_address} ansible_connection=ssh ansible_ssh_user=root\" > inventory &&  ansible-playbook -i inventory playbooks/vagrant.yml"
  }
}
