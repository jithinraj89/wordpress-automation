
This repo contains: 

#### 1. The AWS infrastructure provisioning with terraform ####

        Terraform: terraform modules and varibales.

#### 2. Wordpress deployment playbook with ansible ####

        Ansible:  playbook, role, vault (password_vars), group_vars, dynamic inventory etc.

#### 3. Container orchestration of wordpress application on kubernetes ####

        Kuberntes manifest: Deployment, service objects, ingress, secrets, PV, PVC.

        Wordpress deployment on kubernetes with the help of ansible playbook. 


**1 and 2:- can be done with wordpress_automation.sh script**

**3:- can be done with k8s_wordpress_automation.sh script**

# Fully automated deployment

Please fillup the variables in terraform: ***terraform.tfvars*** and ansible: group_vars, password_vars ***tag_server_role_web*** files with relevent values before starting the fully automated deployment.

Run **wordpress_automation.sh** script to start the fully automated deployment.

```
sh wordpress_automation.sh
```

Wordpress_automation script will provision the entire aws infrastructure and deploy the wordpress applications without any manual intervention.

# Two Step deployment

**Step:1**

*******terraform*******
----------------------

Terraform will create VPC, subnets, ELB, RDS, Security groups and Route53.

Fillup below variables as per the requirements befor running terraform.

Edit "***wordpress-automation/terraform/terraform.tfvars***" 

```
rds_password = "secretpassword"  ## change this in password_vars
aws_region = "us-east-2"
domain_name = "wordpress.subdomain.com"
hosted_zone_id = "XXXXXXXXXXX"
public_key = "ssh-rsa AAAAB3NXXXXXXXXXXX"
ami_id = "ami-7d132e18"

```

Run below command to begin.
```
terraform init
terraform get
terraform plan
```
Run to apply.

```
terraform apply
```

Enter www.wordpress.subdomain.com to view the nginx welcome page, Nginx is installed while provisioning the instance.

terraform will create an output file ***icflix-dev.yml*** with below contents in it.

```
ELB_DNS_NAME: icflix-dev-elb-XXXXXXX.us-east-2.elb.amazonaws.com
DB_HOSTNAME: icflix-dev.clootb0la1lj.us-east-2.rds.amazonaws.com
````

**Step:2**

******ansible******
------------------

Fillup below variables as per the requirements.

Edit "***wordpress-automation/ansible/group_vars/tag_server_role_web***" 

```
subdomain: icflix
WEBSITE_NAME: "wordpress.{{ subdomain }}.com"
DB_HOSTNAME: "icflix-dev.clootb0la1lj.us-east-2.rds.amazonaws.com" ## DB_HOSTNAME from "icflix-dev.yml" file created by terraform.
DB_NAME: "wordpress"
DB_USERNAME: "awsroot"
```
Now run the ***wordpress.yml*** playbook to deploy the wordpress. After successfull deployment wordpress can be accesed from www.wordpress.subdomain.com

```
ansible-playbook -i ec2.py wordpress.yml --vault-password-file .vault_pass.txt
```
