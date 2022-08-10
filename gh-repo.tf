
data "github_repository" "main" {
  full_name = "DevStarOps-org/Managing-GitHub-secrets-using-terraform"
}

resource "github_repository_environment" "main" {
  environment  = var.environment_name
  repository   = data.github_repository.main.id
  reviewers {
    users = var.environment_name == "production" ? [data.github_user.current.id] : null
  }
}

# ARM_CLIENT_ID
resource "github_actions_environment_secret" "ARM_CLIENT_ID" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.main.environment
  secret_name      = "ARM_CLIENT_ID"
  plaintext_value  = azuread_application.main.application_id
}

# ARM_TENANT_ID
resource "github_actions_environment_secret" "ARM_TENANT_ID" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.main.environment
  secret_name      = "ARM_TENANT_ID"
  plaintext_value  = data.azurerm_client_config.current.tenant_id
}

# ARM_SUBSCRIPTION_ID
resource "github_actions_environment_secret" "ARM_SUBSCRIPTION_ID" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.main.environment
  secret_name      = "ARM_SUBSCRIPTION_ID"
  plaintext_value  = data.azurerm_client_config.current.subscription_id
}
