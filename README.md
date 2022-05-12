# Build a secure AWS environment from scratch using Terraform

This repository is a companion for the talk I gave at Devoxx UK 2022.

Create the S3 bucket `terraform-root-state`, then init the project just run `aws-vault exec <profile> -- terraform init`
Then run `terraform plan` and `terraform apply`
