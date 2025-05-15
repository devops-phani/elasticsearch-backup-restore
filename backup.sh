#!/bin/bash

# Define the Elasticsearch credentials and host
ELASTIC_USER="your_elasticsearch_user"
ELASTIC_PASSWORD="your_elasticsearch_password"
ELASTIC_HOST="your_elasticsearch_host"

# List of indices to back up
INDICES=(
  "test1-index1"
  "test1-index2"
)

# Loop through each index in the list
for INDEX in "${INDICES[@]}"
do
  echo "Backing up index: $INDEX"

  # Backup mappings
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump \
    --input=https://$ELASTIC_USER:$ELASTIC_PASSWORD@$ELASTIC_HOST/$INDEX \
    --output=/tmp/backup/$INDEX-mappings.json \
    --type=mapping \
    --insecure
  
  if [ $? -eq 0 ]; then
    echo "Mappings for $INDEX backed up successfully."
  else
    echo "Failed to back up mappings for $INDEX."
  fi

  # Backup data
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump \
    --input=https://$ELASTIC_USER:$ELASTIC_PASSWORD@$ELASTIC_HOST/$INDEX \
    --output=/tmp/backup/$INDEX-data.json \
    --type=data \
    --insecure
  
  if [ $? -eq 0 ]; then
    echo "Data for $INDEX backed up successfully."
  else
    echo "Failed to back up data for $INDEX."
  fi

  echo ""
done
