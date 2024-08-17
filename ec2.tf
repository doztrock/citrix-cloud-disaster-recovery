data "aws_ami" "ami-main-windows" {
  provider    = aws.main
  most_recent = true
  name_regex  = "^Windows_Server-2019-English-Full-Base"
  owners      = ["amazon"]
}

data "aws_ami" "ami-dr-windows" {
  provider    = aws.dr
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

  name          = "DCPD01"
  instance_type = "t3.medium"
  ami           = data.aws_ami.ami-main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = "DCPD01",
    PASSWORD = var.PASSWORD
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

  name          = "CCPD01"
  instance_type = "t3.medium"
  ami           = data.aws_ami.ami-main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = "CCPD01",
    PASSWORD = var.PASSWORD
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

  name          = "GIPD01"
  instance_type = "t3.medium"
  ami           = data.aws_ami.ami-main-windows.id

  iam_instance_profile    = aws_iam_instance_profile.main.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = "GIPD01",
    PASSWORD = var.PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-main.private_subnets, 0)
  vpc_security_group_ids = [
    module.sg-main-private.security_group_id,
    module.sg-main-ssm.security_group_id
  ]

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

  name          = "DCPD51"
  instance_type = "t3.medium"
  ami           = data.aws_ami.ami-dr-windows.id

  iam_instance_profile    = aws_iam_instance_profile.dr.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = "DCPD51",
    PASSWORD = var.PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-dr.public_subnets, 0)
  vpc_security_group_ids = [
    module.sg-dr-private.security_group_id,
    module.sg-dr-ping.security_group_id,
    module.sg-dr-public.security_group_id
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

  name          = "CCPD51"
  instance_type = "t3.medium"
  ami           = data.aws_ami.ami-dr-windows.id

  iam_instance_profile    = aws_iam_instance_profile.dr.name
  disable_api_termination = true

  user_data = templatefile("${path.module}/script/userdata.ps1", {
    HOSTNAME = "CCPD51",
    PASSWORD = var.PASSWORD
  })
  user_data_replace_on_change = true

  subnet_id = element(module.vpc-dr.public_subnets, 1)
  vpc_security_group_ids = [
    module.sg-dr-private.security_group_id,
    module.sg-dr-ping.security_group_id,
    module.sg-dr-public.security_group_id
  ]

}
