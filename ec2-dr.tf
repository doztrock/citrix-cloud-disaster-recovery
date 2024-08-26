data "aws_ami" "dr-windows" {
  provider    = aws.dr
  most_recent = true
  name_regex  = "^Windows_Server-2019-English-Full-Base"
  owners      = ["amazon"]
}

#
# Domain Controller (DR)
#
module "ec2-dr-dc" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "${var.HOSTNAMES.DR_DC}.${var.DOMAIN_NAME}"
  instance_type = "t3.medium"
  ami           = data.aws_ami.dr-windows.id

  iam_instance_profile    = aws_iam_instance_profile.dr.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.HOSTNAMES.DR_DC,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-dr.public_subnets, 0)
  vpc_security_group_ids = [
    module.sg-dr-public.security_group_id,
    module.sg-dr-ping.security_group_id
  ]

}

#
# Cloud Connector (DR)
#
module "ec2-dr-cc" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "${var.HOSTNAMES.DR_CC}.${var.DOMAIN_NAME}"
  instance_type = "t3.medium"
  ami           = data.aws_ami.dr-windows.id

  iam_instance_profile    = aws_iam_instance_profile.dr.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.HOSTNAMES.DR_CC,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-dr.public_subnets, 1)
  vpc_security_group_ids = [
    module.sg-dr-public.security_group_id,
    module.sg-dr-ping.security_group_id
  ]

}
