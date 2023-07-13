# We don't want to store the state file locally, so we need to create a storage
# account to store it in Azure. This is the only 'manual' step in the whole
# process and it only needs to be done once per subscription.

# Variables
RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstate883210 # Must be unique.
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
