provider "aws" {
        region = "us-east-1"
}

variable "secretsmanager_access_role_name" {
  default = "aws-secrets-manager-access-demo-role"
}

variable "secretsmanager_name" {
  default = "kannan/poc"
}

variable "kms_key_name" {
  default = "kannan/poc"
}

data "aws_iam_policy_document" "assume_policy_doc" {
        statement {
                effect = "Allow"
                actions = [ "sts:AssumeRole" ]
                principals {
                        identifiers = [ "ec2.amazonaws.com" ]
                        type = "Service"
                }
        }
}

resource "aws_iam_role" "role" {
        name = var.secretsmanager_access_role_name
        path = "/"
        assume_role_policy = data.aws_iam_policy_document.assume_policy_doc.json
}

data "aws_iam_policy_document" "sms_access_policy_doc" {
        statement {
                actions = [ "secretsmanager:GetSecretValue" ]
                resources = ["arn:aws:secretsmanager:us-east-1:496213958842:secret:${var.secretsmanager_name}*"]
        }
        statement {
                actions = ["kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*", "kms:CreateGrant", "kms:DescribeKey"]
                resources = ["arn:aws:kms:us-east-1:496213958842:alias/${var.kms_key_name}"]
        }
}

resource "aws_iam_policy" "sms_access_policy" {
        name = "secrets-manager-access-policy"
        path = "/"
        policy = data.aws_iam_policy_document.sms_access_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "sms_access_policy_attachment" {
        depends_on = [ aws_iam_role.role ]
        role = aws_iam_role.role.name
        policy_arn = aws_iam_policy.sms_access_policy.arn
}

data "aws_kms_alias" "poc" {
  name = "alias/${var.kms_key_name}"
}

resource "aws_kms_grant" "grant" {
  name              = "poc-key-grant"
  key_id            = data.aws_kms_alias.poc.target_key_id
  grantee_principal = aws_iam_role.role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

