terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-root-state"
    dynamodb_table = "terraform-root-lock"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

module "backend_root" {
  source      = "./modules/backend"
  bucket_name = "terraform-root-state"
  table_name  = "terraform-root-lock"
}

# Master account
provider "aws" {
  region = "us-east-1"
}

# For users and automation users account
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.users.id}:role/Admin"
  }

  alias  = "users"
  region = "us-east-1"
}

# For dev, staging and prod
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dev.id}:role/Admin"
  }

  alias  = "dev"
  region = "us-east-1"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.staging.id}:role/Admin"
  }

  alias  = "staging"
  region = "us-east-1"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.production.id}:role/Admin"
  }

  alias  = "production"
  region = "us-east-1"
}

