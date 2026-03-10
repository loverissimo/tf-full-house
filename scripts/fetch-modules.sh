#!/bin/bash

MODULE_NAME=$1
DEST_DIR=$2
OWNER="loverissimo"
REPO="terraform-repository"
BRANCH="master"

if [ -z "$MODULE_NAME" ] || [ -z "$DEST_DIR" ]; then
  echo "Usage: fetch-module.sh <module_name> <dest_dir>"
  exit 1
fi

mkdir -p "$DEST_DIR"

echo "Searching for module: $MODULE_NAME"

# Get theme folders
THEMES=$(curl -s https://api.github.com/repos/$OWNER/$REPO/contents/azure?ref=$BRANCH | jq -r '.[].name')

FOUND_PATH=""

for theme in $THEMES; do
  MODULE_PATH="azure/$theme/$MODULE_NAME"

  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  https://api.github.com/repos/$OWNER/$REPO/contents/$MODULE_PATH?ref=$BRANCH)

  if [ "$RESPONSE" = "200" ]; then
    FOUND_PATH=$MODULE_PATH
    break
  fi
done

if [ -z "$FOUND_PATH" ]; then
  echo "Module '$MODULE_NAME' not found in repository."
  exit 1
fi

echo "Module found at $FOUND_PATH"

# Fetch files
FILES=$(curl -s https://api.github.com/repos/$OWNER/$REPO/contents/$FOUND_PATH?ref=$BRANCH | jq -r '.[].download_url')

for file in $FILES; do
  curl -s "$file" -o "$DEST_DIR/$(basename $file)"
done

echo "Module '$MODULE_NAME' fetched to '$DEST_DIR'"