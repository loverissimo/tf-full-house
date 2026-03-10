#!/bin/bash
# fetch-module.sh
RESOURCE=$1           # e.g., vnet, vm, subnet
DEST_PATH=$2          # e.g., resources/vnet
AZURE_DEVOPS_PAT="AZyWcIfxq1AGfaIFO6wnBUC4eFnnfJM6qlIsOdoSlaRMmwNOZPY2JQQJ99CCACAAAAAxJCnnAAASAZDO2mLj"

if [ -z "$RESOURCE" ]; then
  echo "Error: module name not provided"
  exit 1
fi

if [ -z "$DEST_PATH" ]; then
  echo "Error: destination path not provided"
  exit 1
fi

if [ -z "$AZURE_DEVOPS_PAT" ]; then
  echo "Error: AZURE_DEVOPS_PAT is not set"
  exit 1
fi

# Clone repo to temp folder
TMP_DIR=".terraform-temp"

rm -rf "$TMP_DIR"
mkdir "$TMP_DIR"

git clone "https://$AZURE_DEVOPS_PAT@dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure" "$TMP_DIR"

# Find module anywhere inside tested and working
SRC_MODULE=$(find "$TMP_DIR/child modules/tested and working" -type d -name "$RESOURCE" | head -n 1)

if [ -z "$SRC_MODULE" ]; then
  echo "Error: module $RESOURCE not found in repo"
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

echo "Module $RESOURCE copied to $DEST_PATH"