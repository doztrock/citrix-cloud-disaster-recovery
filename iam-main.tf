resource "aws_iam_role" "main-ec2" {

  provider = aws.main

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

}

resource "aws_iam_instance_profile" "main" {
  provider = aws.main
  name     = "instance-profile-main"
  role     = aws_iam_role.main-ec2.name
}
