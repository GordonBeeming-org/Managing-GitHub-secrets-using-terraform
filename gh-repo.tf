
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

# STORAGE_CONNECTION
resource "github_actions_environment_secret" "STORAGE_CONNECTION" {
  repository       = data.github_repository.main.id
  environment      = github_repository_environment.main.environment
  secret_name      = "STORAGE_CONNECTION"
  plaintext_value  = azurerm_storage_account.main.primary_connection_string
}

