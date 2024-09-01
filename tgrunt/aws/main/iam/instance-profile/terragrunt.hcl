include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../terraform-modules/instance-profile"
}

inputs = {
  name = "instance-profile-main"
}
