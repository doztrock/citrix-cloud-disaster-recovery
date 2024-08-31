resource "aws_ami_from_instance" "main" {
  provider                = aws.main
  count                   = var.IS_GI_READY ? 1 : 0
  name                    = module.ec2-main-gi.tags_all["Name"]
  source_instance_id      = module.ec2-main-gi.id
  snapshot_without_reboot = false
}

resource "aws_ami_copy" "dr" {
  provider          = aws.dr
  count             = var.IS_GI_READY ? 1 : 0
  name              = module.ec2-main-gi.tags_all["Name"]
  source_ami_id     = aws_ami_from_instance.main[0].id
  source_ami_region = data.aws_region.main.name
}
