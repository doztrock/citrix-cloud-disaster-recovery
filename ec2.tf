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

resource "tls_private_key" "private-key-main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "private-key-dr" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private-key-main" {
  filename = "${path.module}/key/main.pem"
  content  = tls_private_key.private-key-main.private_key_pem
}

resource "local_file" "private-key-dr" {
  filename = "${path.module}/key/dr.pem"
  content  = tls_private_key.private-key-dr.private_key_pem
}

module "key-pair-main" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.3"

  key_name   = "main"
  public_key = trimspace(tls_private_key.private-key-main.public_key_openssh)

}

module "key-pair-dr" {

  providers = {
    aws = aws.dr
  }

  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.3"

  key_name   = "dr"
  public_key = trimspace(tls_private_key.private-key-dr.public_key_openssh)

}

module "ec2-main-dc" {

  providers = {
    aws = aws.main
  }

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name          = "DCPD01"
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami-main-windows.id

  key_name                = module.key-pair-main.key_pair_name
  disable_api_termination = true

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
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami-dr-windows.id

  key_name                = module.key-pair-dr.key_pair_name
  disable_api_termination = true

  subnet_id              = element(module.vpc-dr.public_subnets, 0)
  vpc_security_group_ids = [module.sg-dr.security_group_id]

}
