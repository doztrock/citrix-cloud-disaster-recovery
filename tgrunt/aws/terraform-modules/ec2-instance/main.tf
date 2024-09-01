data "aws_ami" "windows" {
  most_recent = true
  name_regex  = "^Windows_Server-2019-English-Full-Base"
  owners      = ["amazon"]
}

locals {
  fqdn = "${var.hostname}.${var.domain_name}"
}

module "ec2-instance" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name = local.fqdn

  instance_type = var.instance_type
  ami           = data.aws_ami.windows.id

  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = true

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.hostname,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

}
