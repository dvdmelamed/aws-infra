module "github-oidc-dev" {
  source = "./modules/github-oidc"
  client_id_list = local.github_organisations
  full_repository_name = local.full_repository_name
  name = "GithubActionDevRole"

  providers = {
    aws = aws.dev
  }
}

module "github-oidc-staging" {
  source = "./modules/github-oidc"
  client_id_list = local.github_organisations
  full_repository_name = local.full_repository_name
  name = "GithubActionStagingRole"

  providers = {
    aws = aws.staging
  }
}

module "github-oidc-prod" {
  source = "./modules/github-oidc"
  client_id_list = local.github_organisations
  full_repository_name = local.full_repository_name
  name = "GithubActionProdRole"

  providers = {
    aws = aws.production
  }
}