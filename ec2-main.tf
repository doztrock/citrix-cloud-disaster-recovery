data "aws_ami" "main-windows" {
  provider    = aws.main
  most_recent = true
  name_regex  = "^Windows_Server-2019-English-Full-Base"
  owners      = ["amazon"]
}

#
# Domain Controller (Main)
#
module "ec2-main-dc" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "${var.HOSTNAMES.MAIN_DC}.${var.DOMAIN_NAME}"
  instance_type = "t3.medium"
  ami           = data.aws_ami.main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.HOSTNAMES.MAIN_DC,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-main.public_subnets, 0)
  vpc_security_group_ids = [
    module.sg-main-private.security_group_id,
    module.sg-main-ping.security_group_id,
    module.sg-main-public.security_group_id
  ]

}

#
# Cloud Connector (Main)
#
module "ec2-main-cc" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "${var.HOSTNAMES.MAIN_CC}.${var.DOMAIN_NAME}"
  instance_type = "t3.medium"
  ami           = data.aws_ami.main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.HOSTNAMES.MAIN_CC,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-main.public_subnets, 1)
  vpc_security_group_ids = [
    module.sg-main-private.security_group_id,
    module.sg-main-ping.security_group_id,
    module.sg-main-public.security_group_id
  ]

}

#
# Golden Image (Main)
#
module "ec2-main-gi" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "${var.HOSTNAMES.MAIN_GI}.${var.DOMAIN_NAME}"
  instance_type = "t3.medium"
  ami           = data.aws_ami.main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = var.HOSTNAMES.MAIN_GI,
    USERNAME = var.ADMINISTRATOR_USERNAME,
    PASSWORD = var.ADMINISTRATOR_PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-main.private_subnets, 0)
  vpc_security_group_ids = [
    module.sg-main-private.security_group_id,
    module.sg-main-ssm.security_group_id
  ]

}
