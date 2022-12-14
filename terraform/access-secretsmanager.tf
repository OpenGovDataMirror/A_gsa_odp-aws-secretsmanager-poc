
variable "secretsmanager_name" {
  default = "kannan/poc"
}

data "aws_secretsmanager_secret" "secretsmanager_name" {
  name = var.secretsmanager_name
}

data "aws_secretsmanager_secret_version" "latest" {
  secret_id = data.aws_secretsmanager_secret.secretsmanager_name.id
}

output "secret" {
  value = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["api-key"]
}