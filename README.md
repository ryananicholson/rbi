# Remote Browser Isolation PoC

Deploys an Azure VM (with all required networking) running KASM for remote browser isolation.

# Pre-requisites

- Azure CLI
- Terraform

# To Deploy:

Log into Azure by running the following command and following the instructions:

```
az login
```

If login is successful, run the following Terraform commands to deploy to Azure.

```
terraform init
terraform plan
terraform apply # Answering 'y' if the plan succeeds
```

# What now?

Your Terraform output will show your Linux VM IP address and password. Log in with `student` via SSH to that IP address and use the supplied password. Once connected, review the /root/kasm_install.txt file for your KASM credentials. 

After roughly 15 minutes of the deployment succeeding, you can connect to KASM by navigating to your Azure Front Door URL which can be found by running the following Azure CLI command on your host system and looking for the hostName entry:

```
az extension add --name front-door
az network front-door list
```
