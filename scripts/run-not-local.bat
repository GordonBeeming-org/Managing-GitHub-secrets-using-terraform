cd ..
terraform init -reconfigure -var-file="envs/test.tfvars" -backend-config="envs/test.tfbackend"
terraform plan -input=false -var-file="envs/test.tfvars" -out="envs/test.tfplan"
terraform apply -auto-approve "envs/test.tfplan"

terraform init -reconfigure -var-file="envs/production.tfvars" -backend-config="envs/production.tfbackend"
terraform plan -input=false -var-file="envs/production.tfvars" -out="envs/production.tfplan"
terraform apply -auto-approve "envs/production.tfplan"

terraform init -reconfigure -var-file="envs/local.tfvars" -backend-config="envs/local.tfbackend"
cd scripts