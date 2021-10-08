# login to Azure
az login

#creating the resource Group
az group create -n AksTerraform-RG -l AustraliaEast

#creating the storage account
az storage account create -n 'terraformbuild081021' -g AksTerraform-RG -l AustraliaEast
#creating a tfstate container
az storage container create -n tfstate --account-name 'terraformbuild081021'
#creating the KeyVault
az keyvault create -n AksTerraform-kv -g AksTerraform-RG -l AustraliaEast

#Creating a SAS Token for the storage account, storing in KeyVault
az storage container generate-sas --account-name 'terraformbuild081021' --expiry 2022-01-01 --name tfstate --permissions dlrw -o json | xargs az keyvault secret set --vault-name AksTerraform-kv --name TerraformSASToken --value
#creating a Service Principal for AKS and Azure DevOps
az ad sp create-for-rbac -n "AksTerraformSPN"
#creating an ssh key if you don't already have one
ssh-keygen  -f .\id_rsa_terraform
#store the public key in Azure KeyVault
az keyvault secret set --vault-name AksTerraform-kv --name LinuxSSHPubKey -f .\id_rsa_terraform.pub 
#store the service principal id in Azure KeyVault
az keyvault secret set --vault-name AksTerraform-kv --name spn-id --value "ID" /dev/null
#store the service principal secret in Azure KeyVault
az keyvault secret set --vault-name AksTerraform-kv --name spn-secret --value "Secret" /dev/null

