cd ..
terraform apply -auto-approve %* "envs/local.tfplan"
cd scripts