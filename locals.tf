locals {
  domains = {
    "dev": "domain-dev.io",
    "staging": "domain.io",
    "prod": "domain.io"
  }

  accounts = {
    users = {
      name = "users",
      owner = "users@domain.io"
    },
    dev = {
      name = "dev",
      owner = "dev@domain.io"
    },
    staging = {
      name = "staging",
      owner = "stage@domain.io"
    },
    production = {
      name = "production",
      owner = "prod@domain.io"
    }
  }

  # Custom accounts
  dev_accounts = {
    team1 = {
      name      = "team1",
      subdomain = "team1",
      owner     = "aws-dev+team1@domain.io"
    }
  }

  ous = {
    "users"     = aws_organizations_organizational_unit.users
    "sandbox"   = aws_organizations_organizational_unit.sandbox
    "workloads" = aws_organizations_organizational_unit.workloads
  }

  # Repository that has access to AWS
  full_repository_name = "github_org/repository"

  github_organisations = [
    "https://github.com/github_org"
  ]

  dns_records = {
    "acm_validation" : { "type" = "CNAME", "ttl" = 60, "name" = "_fdsfsdfsdfd", "records" = ["_fsdfsdfsdfd.sfsfsdfsdf.acm-validations.aws."] },
  }

  users = {
    "johndoe" = {
      name = "john.doe",
      pgp_key = "keybase:johndoe"
      has_console_access = true
      groups = [
        module.self-managing-group-user.name,
        module.super_admin_group.group_name,
        module.team1_group.group_name,
      ]
    }
  }

  roles = {
    "admin": {
      "role_name": "Administrator",
      "policy_name": "Administrator"
    },
    "readonly": {
      "role_name": "Readonly",
      "policy_name": "ReadOnly"
    }
  }
}
