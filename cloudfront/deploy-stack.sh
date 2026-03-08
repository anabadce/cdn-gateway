#!/bin/bash

# === CONFIG ===
STACK_NAME="cloudfront-stack"
TEMPLATE_FILE="cloudformation-cloudfront.yaml"
PARAM_FILE="config.json"
PROFILE="default"
REGION="us-east-1" # This is the global region used by Cloudfront
CAPABILITIES="CAPABILITY_NAMED_IAM"

echo "INFO: Checking credentials..."
if ! aws sts get-caller-identity; then
  exit 0
fi

# === CHECK IF STACK EXISTS ===
echo "INFO: Checking if stack '$STACK_NAME' exists..."
if aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --profile "$PROFILE" \
  --region "$REGION" >/dev/null 2>&1; then
  ACTION="update-stack"
  echo "INFO: Stack exists. Updating..."
else
  ACTION="create-stack"
  echo "INFO: Stack does not exist. Creating..."
fi

# === DEPLOY STACK ===
aws cloudformation $ACTION \
  --stack-name "$STACK_NAME" \
  --template-body "file://$TEMPLATE_FILE" \
  --parameters "file://$PARAM_FILE" \
  --capabilities "$CAPABILITIES" \
  --profile "$PROFILE" \
  --region "$REGION"
