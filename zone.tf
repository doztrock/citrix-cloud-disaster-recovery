resource "citrix_zone" "main" {
  resource_location_id = citrix_cloud_resource_location.main.id
}

resource "citrix_zone" "dr" {
  resource_location_id = citrix_cloud_resource_location.dr.id
}
