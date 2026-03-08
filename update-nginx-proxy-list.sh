#!/bin/bash -e

if which curl > /dev/null && which jq > /dev/null; then
  echo "-- Starting..."
else
  echo "-- This scripts needs curl and jq installed"
  exit 1
fi

DIRNAME=$(dirname $0)
pushd "$DIRNAME" > /dev/null

AWS_LIST=https://ip-ranges.amazonaws.com/ip-ranges.json
FILE_HEADER="# File populated by $0"
FILE_LIST="./nginx/conf.d/trusted-proxies.include"

CLOUDFRONT_LIST=$(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json \
  | jq '.prefixes[] | select(.service | contains("CLOUDFRONT")) | { ip_prefix: .ip_prefix }'
)

echo "-- Found $(echo $CLOUDFRONT_LIST | jq .ip_prefix | wc -l) IP prefixes..."

FILE_CONTENT=$(echo "$FILE_HEADER" ; \
  echo $CLOUDFRONT_LIST \
  | jq -r .ip_prefix \
  | awk '{ print("set_real_ip_from " $1 ";")}'
)

echo "$FILE_CONTENT" > "$FILE_LIST"

popd > /dev/null

echo "-- Entries in file: $(wc -l $FILE_LIST)"
