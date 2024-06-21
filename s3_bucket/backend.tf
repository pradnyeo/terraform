terraform {
  backend "s3" {
    bucket = "my-test-pradnyeo"
    key = "my-test-pradnyeo/terraform.tfstate"
    region = "ap-south-1"    
  }
}