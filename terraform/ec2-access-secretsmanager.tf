variable "secretsmanager_access_role_name" {
  default = "aws-secrets-manager-access-demo-role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile_for_poc"
  role = var.secretsmanager_access_role_name
}

resource "aws_instance" "test_machine" {
  ami = "ami-0e609024e4dbce4a5"
  instance_type = "t2.micro"
  subnet_id = "subnet-e26556a4"
  vpc_security_group_ids = ["sg-03f10038db28367ae"]
  key_name = "kannan-dev"
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  tags = {
    "Name" = "aws-secrets-manager-demo"
    "instance-parker" = "workdays"
  }
}