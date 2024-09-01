include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../terraform-modules/vpc"
}

inputs = {

  name = "main"
  cidr = "10.10.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

}
