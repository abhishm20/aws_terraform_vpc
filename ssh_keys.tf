resource "aws_key_pair" "bastion-host" {
  key_name   = "${var.app_name}-bastion-host"
  public_key = file("${path.root}/ssh_keys/bastion_host.pub")
}

resource "aws_key_pair" "ansible-server-key" {
  key_name   = "${var.app_name}-ansible-server"
  public_key = file("${path.root}/ssh_keys/ansible_server.pub")
}

resource "aws_key_pair" "ansible-hosts-key" {
  key_name   = "${var.app_name}-ansible-hosts"
  public_key = file("${path.root}/ssh_keys/ansible_hosts.pub")
}