output "AWS_ACCESS_KEY_ID" {
  value = var.AWS_ACCESS_KEY_ID
}

output "AWS_SECRET_ACCESS_KEY" {
  value = var.AWS_SECRET_ACCESS_KEY
  sensitive = true
}

output "AWS_REGION" {
  value = var.AWS_REGION
}
