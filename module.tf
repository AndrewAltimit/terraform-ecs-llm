terraform {
  backend "s3" {
    bucket = "altimit"
    key    = "terraform/privatellm/tfstate"
    region = "us-east-1"
  }
}
