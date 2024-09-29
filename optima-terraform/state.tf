terraform {
  backend "s3" {
    bucket = "business-optima-solutions-project"
    key    = "business-optima/terraform.tfstate"
    region = "ap-south-1"
  }
}