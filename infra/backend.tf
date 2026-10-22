terraform {
  backend "s3" {
    bucket       = "fider-terraform-state-365152039069-euw2"
    key          = "fider/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}