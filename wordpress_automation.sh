#!/bin/sh
bold=$(tput bold)
normal=$(tput sgr0)
echo "Please fillup the variables in ${bold}wordpress-automation/terraform/terraform.tfvars${normal} and ${bold}wordpress-automation/ansible/group_vars/tag_server_role_web${normal} files with relevent values."
while true; do
    read -p 'Type Y to continue N to abort:' yn

    echo ""
		echo ""
		echo ""
		
    case $yn in
        [Yy]* ) echo "${bold}Starting AWS provisioning with terraform................!${normal}"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

    echo ""
		echo ""
		echo ""

cd terraform && terraform get && terraform init && terraform plan && terraform apply 

echo "${bold}Starting wordpress deployment with ansible (Please wait)...........!!!${normal}"

echo ""
echo ""
echo ""

cd ansible 
ansible-playbook -i ec2.py wordpress.yml --extra-vars=@../terraform/icflix-dev.yml --vault-password-file .vault_pass.txt
