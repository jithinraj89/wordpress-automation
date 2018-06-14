#!/bin/sh
bold=$(tput bold)
normal=$(tput sgr0)
echo "Please fillup the variables in ${bold}\033[33;31m kubernetes/terraform-k8s-wordpress/terraform.tfvars${normal} and ${bold}\033[33;31m kubernetes/ansible-k8s-wordpress/group_vars/prod${normal} files with relevent values before proceeding."
while true; do
    read -p 'Type Y to continue N to abort:' yn

    echo ""
		echo ""
		echo ""
		
    case $yn in
        [Yy]* ) echo "${bold}Provisioning EFS for kubernetes volumes................!${normal}"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

    echo ""
		echo ""
		echo ""

cd terraform-k8s-wordpress && terraform init && terraform get && terraform plan && terraform apply 

echo "${bold}Starting wordpress deployment on kubernetes (Please wait)...........!!!${normal}"

echo ""
echo ""
echo ""

cd ansible-k8s-wordpress 

ansible-playbook -i inventory/prod wordpress.yml --extra-vars=@../terraform-k8s-wordpress/icflix-efs.yml  --vault-password-file .vault_pass.txt