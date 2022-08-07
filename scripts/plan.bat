cd ..
terraform plan -input=false -var-file="envs/local.tfvars" -out="envs/local.tfplan" %*
cd scripts