resource "aws_ecr_repository" "main" {
  name                 = "fider"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "fider-ecr"
  }
}