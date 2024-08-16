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

  subnet_id              = element(module.vpc-main.public_subnets, 0)
  vpc_security_group_ids = [module.sg-main.security_group_id]

}

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

  subnet_id              = element(module.vpc-dr.public_subnets, 0)
  vpc_security_group_ids = [module.sg-dr.security_group_id]

}
