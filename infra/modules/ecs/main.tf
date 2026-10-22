resource "aws_ecs_cluster" "main" {
  name = "fider-cluster"

  tags = {
    Name = "fider-cluster"
  }
}