# Kubernetes fully automated deployment

Please fillup the variables in k8s-terraform: kubernetes/terraform-k8s-wordpress/***terraform.tfvars*** and k8s-ansible: kubernetes/ansible-k8s-wordpress/group_vars, password_vars/***prod*** files with relevent values before running k8s_wordpress_automation script ."

Note:
**To use the SSL, add ssl key in tls.key and ssl cert in tls.crt files inside the roles/k8s_wordpress/files/manifest directory use ansible vault to encrypt** ( key in .vault_pass.txt )

Run **k8s_wordpress_automation.sh** script to start the Kubernetes fully automated deployment.

```
sh k8s_wordpress_automation.sh
```

K8s_wordpress_automation script will provision the EFS volumes which is used as the persistant volume mount for the pods and deploys the wordpress applications in kubernetes cluster without any manual intervention.
