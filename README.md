# Build a secure AWS environment from scratch using Terraform

This repository is a companion for the talk I gave at "The Big Dev Theory", entitled "The Security Journey of a Startup - from MVS to Co-Selling with AWS".

Create the S3 bucket `terraform-root-state`, then init the project just run `aws-vault exec <profile> -- terraform init`
Then run `terraform plan` and `terraform apply`
