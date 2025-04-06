#!/bin/bash

set -e  # Exit on first error

terraform init -upgrade
echo "Applying Terraform..."
if ! terraform apply -auto-approve 2> error.log; then
  echo "Terraform apply failed! Destroying resources..."
  terraform destroy -auto-approve
  
  echo -e "\n❌ Terraform apply failed with the following error:"
cat error.log  # Echo the captured error
rm error.log
  rm error.log
  exit 1
fi

echo "Terraform apply succeeded!"
terraform destroy -auto-approve
echo "Terraform apply succeeded! Resources destroyed"
