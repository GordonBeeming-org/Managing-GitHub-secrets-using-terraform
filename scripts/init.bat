cd ..
terraform init -var-file="envs/local.tfvars" -backend-config="envs/local.tfbackend" %*
cd scripts