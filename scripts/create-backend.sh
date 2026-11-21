#!/usr/bin/env bash

# exit on error
set -e

RESOURCE_GROUP_NAME=sgs-2-tf-state-backend-rg
STORAGE_ACCOUNT_NAME=sgs2storg4653
CONTAINER_NAME=sgs-2-cunt-4653
ACCOUNT_KEY=""
LOCATION=centralindia

log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log_success() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $1"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1"
}

# Create resource group
if az group exists --name "$RESOURCE_GROUP_NAME" | grep -q true; then
    log_info "Resource Group already exists: $RESOURCE_GROUP_NAME"
else
    log_info "Creating Resource Group: $RESOURCE_GROUP_NAME"

    if az group create --name $RESOURCE_GROUP_NAME --location $LOCATION > /dev/null
    then
        log_success "Resource Group Created: $RESOURCE_GROUP_NAME"
    else
        log_error "Failed to create Resource Group: $RESOURCE_GROUP_NAME"
        exit 1
    fi
fi


# Create Storage Account
if az storage account show --resource-group "$RESOURCE_GROUP_NAME" --name "$STORAGE_ACCOUNT_NAME" > /dev/null 2>&1
then
    log_info "Storage account already exists: $STORAGE_ACCOUNT_NAME"
else
    log_info "Creating Storage Account: $STORAGE_ACCOUNT_NAME"

    if az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob > /dev/null
    then
        log_success "Storage Account created: $STORAGE_ACCOUNT_NAME"
    else
        log_error "Failed to create Storage Account: $STORAGE_ACCOUNT_NAME"
        exit 1
    fi
fi

# Fetch Storage Account Key
log_info "Fetching Storage Account Key"

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

if [ -n "$ACCOUNT_KEY" ]; then
    log_success "Storage Account Key fetched Succesfully!"
else
    log_success "Failed to retrieve Storage Account Key!"
    exit 1
fi

# Create blob container
if az storage container exists --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY" --query exists -o tsv | grep -q true > /dev/null;
then
    log_info "Container already exists: $CONTAINER_NAME"
else
    log_info "Creating Blob Container: $CONTAINER_NAME"

    if az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY > /dev/null
    then
        log_success "Blob Container created: $CONTAINER_NAME"
    else
        log_error "Failed to create Blob Container"
        exit 1
    fi
fi


echo
log_success "Terraform Backend created successfully!"
echo "---------------------------------------------------------"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Container Name: $CONTAINER_NAME"
echo "Location: $LOCATION"
echo "---------------------------------------------------------"
