include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../terraform-modules/vpc"
}

inputs = {

  name = "dr"
  cidr = "10.20.0.0/16"

}
