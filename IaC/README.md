# Credentials 

## Terraform auth

```
az logout
az login --use-device-code

export TF_VAR_SUBSCRIPTION_ID=$(az account list | jq -r '.[0].id')
export TF_VAR_TENANT_ID=$(az account list | jq -r '.[0].tenantId')

az account set --subscription $TF_VAR_SUBSCRIPTION_ID

SP_TERRAFORM_INFO=$(az ad sp create-for-rbac --name terraform-contributor --role Contributor --scopes /subscriptions/$TF_VAR_SUBSCRIPTION_ID)

export TF_VAR_SP_TERRAFORM_ID=$(echo $SP_TERRAFORM_INFO | jq -r ".appId")

export TF_VAR_SP_TERRAFORM_SECRET=$(echo $SP_TERRAFORM_INFO | jq -r ".password")

az role assignment create --assignee $TF_VAR_SP_TERRAFORM_ID --role "Storage Blob Data Owner" --scope /subscriptions/$TF_VAR_SUBSCRIPTION_ID
```

## Create Datalake SP

```
SP_DATA_LAKE_CONTRIBUTOR_INFO=$(az ad sp create-for-rbac --name sp-datalake-contributor --role Reader)

export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_ID=$(echo $SP_DATA_LAKE_CONTRIBUTOR_INFO | jq -r ".appId")

export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_SECRET=$(echo $SP_DATA_LAKE_CONTRIBUTOR_INFO | jq -r ".password")

export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_OBJ_ID=$(az ad sp show --id $TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_ID | jq -r ".objectId")
```

### Create .env
```
echo export TF_VAR_SUBSCRIPTION_ID=$TF_VAR_SUBSCRIPTION_ID > .env
echo export TF_VAR_TENANT_ID=$TF_VAR_TENANT_ID >> .env
echo export TF_VAR_SP_TERRAFORM_ID=$TF_VAR_SP_TERRAFORM_ID >> .env
echo export TF_VAR_SP_TERRAFORM_SECRET=$TF_VAR_SP_TERRAFORM_SECRET >> .env
echo export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_ID=$TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_ID >> .env
echo export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_SECRET=$TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_SECRET >> .env
echo export TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_OBJ_ID=$TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_OBJ_ID >> .env
```

### Reload .env
```
source .env 
```

## Delete Datalake SP
```
az ad sp delete --id $TF_VAR_SP_TERRAFORM_ID
az ad sp delete --id $TF_VAR_SP_DATA_LAKE_CONTRIBUTOR_ID
```

# Terraform commands

```
terraform init

terraform plan

terraform apply

terraform destroy
```
