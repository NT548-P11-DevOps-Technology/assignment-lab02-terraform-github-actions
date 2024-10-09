provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = var.default_tags
  }
}

provider "tls" {}
provider "http" {}
provider "local" {}
