resource "aws_ecr_repository" "services" {
  for_each             = toset(var.service_names)
  name                 = "investments-${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = true }

  encryption_configuration { encryption_type = "AES256" }
}
