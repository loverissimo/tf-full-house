#!/bin/bash
# fetch-module.sh
RESOURCE=$1           # e.g., vnet, vm, subnet
DEST_PATH=$2          # e.g., resources/vnet

if [ -z "$AZURE_DEVOPS_PAT" ]; then
  echo "Error: AZURE_DEVOPS_PAT is not set"
  exit 1
fi

# Clone repo to temp folder
TMP_DIR=".terraform-temp"
rm -rf "$TMP_DIR"
mkdir "$TMP_DIR"

git clone "https://$AZURE_DEVOPS_PAT@dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure" "$TMP_DIR"

# Copy module folder
SRC_MODULE="$TMP_DIR/child modules/tested and working/$MODULE_NAME"
if [ ! -d "$SRC_MODULE" ]; then
  echo "Error: module $MODULE_NAME not found in repo"
  rm -rf "$TMP_DIR"
  exit 1
fi

mkdir -p "$DEST_PATH"
cp -r "$SRC_MODULE"/* "$DEST_PATH/"

# Copy status.md if exists
if [ -f "$SRC_MODULE/status.md" ]; then
  cp "$SRC_MODULE/status.md" "$DEST_PATH/status.md"
fi

# Clean up
rm -rf "$TMP_DIR"
echo "Module $MODULE_NAME copied to $DEST_PATH"