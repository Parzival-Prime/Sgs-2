#!/usr/bin/env bash

RESOURCE_GROUP_NAME=sgs-2-tf-state-backend-rg

log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log_success() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $1"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1"
}

# delete the Resource Group
if az.cmd group exists --name $RESOURCE_GROUP_NAME | grep -q true; then
    log_info "Deleting the Resource Group: $RESOURCE_GROUP_NAME"

    if az.cmd group delete --name $RESOURCE_GROUP_NAME -y > /dev/null; then
        log_success "Resource Group Deleted Successfully!"
    else
        log_error "Failed to delete Resource Group!"
        exit 1
    fi
else
    log_info "Resource Group does not exists: $RESOURCE_GROUP_NAME"
fi


echo 
log_success "Terraform Backend CleanUp Successful!"