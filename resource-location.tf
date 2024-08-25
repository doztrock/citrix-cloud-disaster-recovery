resource "citrix_cloud_resource_location" "main" {
  name = "AWS (${data.aws_region.main.name})"
}

resource "citrix_cloud_resource_location" "dr" {
  name = "AWS (${data.aws_region.dr.name})"
}
