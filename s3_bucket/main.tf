provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "testo" {
    bucket = "my-test-pradnyeo"
    tags = {
      Name = "my-test-pradnyeo"
    }
}