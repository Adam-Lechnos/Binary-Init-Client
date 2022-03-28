#!/bin/bash

branch=$1

if [[ -z $branch ]]; then branch="main"; else endEcho="Use Terraform with caution and ensure no Prod state files are being upgraded!\nExecute this command without specfying a branch for Prod sanctioned binaries"; fi

#Terraform Binary URL
TFvar=`curl -s "https://raw.github.<domain>.com/<org>/<config location>/${branch}/pipeline_files/binary_versions" | jq -r '.base_binaries | to_entries | map(select(.key | match("terraform"))) | map(.value) | .[]'`

#Terragrunt Binary URL
TGvar=`curl -s "https://raw.github.<domain>.com/<org>/<config location>/${branch}/pipeline_files/binary_versions" | jq -r '.base_binaries | to_entries | map(select(.key | match("terragrunt"))) | map(.value) | .[]'`

wgetTestTF=`wget --server-response --spider "https://releases.hashicorp.com/terraform/${TFvar}/terraform_${TFvar}_linux_amd64.zip" 2>&1 | grep -c '200 OK'`
wgetTestTG=`wget --server-response --spider "https://github.com/gruntwork-io/terragrunt/releases/download/v${TGvar}/terragrunt_linux_amd64" 2>&1 | grep -c '200 OK'` 2>&1> /dev/null

mkdir -p ~/binary-init-cache
cd ~/binary-init-cache

echo "------------------------------------"
echo "Downloading the following binaries.."
echo "------------------------------------"
echo "--Terraform--"
if [[ $? == 0 && $wgetTestTF == 1 ]]; then wget -q "https://releases.hashicorp.com/terraform/${TFvar}/terraform_${TFvar}_linux_amd64.zip" -O terraform && unzip -o -q terraform; else printf "Failed, exiting..\nCheck if '${branch}' branch exists\n" && exit 1; fi
echo "--Terragrunt--"
if [[ $? == 0 && $wgetTestTG == 1 ]]; then wget -q wget -q "https://github.com/gruntwork-io/terragrunt/releases/download/v${TGvar}/terragrunt_linux_amd64" -O terragrunt; else printf "Failed, exiting..\nCheck if '${branch}' branch exists\n" && exit 1; fi
chmod +x terragrunt

echo "----------------------------"
echo "Validating binary versions.."
echo "----------------------------"
echo "--Terraform--"
./terraform -v | head -n 1
if [[ $? != 0 ]]; then echo "Failed, exiting" && exit 1; fi
echo "--Terragrunt--"
./terragrunt -v | head -n 1
if [[ $? != 0 ]]; then echo "Failed, exiting" && exit 1; fi
echo "---------"
echo "Completed"
echo "---------"

if [[ -z $endEcho ]]; then echo "sourced from Prod\\Master branch"; else printf "sourced from '${branch}' branch\n${endEcho}\n"; fi

exit 0
