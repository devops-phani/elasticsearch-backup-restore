#!/bin/bash

# Define the Elasticsearch credentials and host
ELASTIC_USER="your_elasticsearch_user"
ELASTIC_PASSWORD="your_elasticsearch_password"
ELASTIC_HOST="your_elasticsearch_host"

# Map backup indexes to restore indexes
declare -A INDEX_MAP=(
  ["test1-index1"]="test2-index1"
  ["test1-index2"]="test2-index2"
)

# Loop through each backup index and restore it to the mapped restore index
for BACKUP_INDEX in "${!INDEX_MAP[@]}"
do
  RESTORE_INDEX="${INDEX_MAP[$BACKUP_INDEX]}"
  echo "Restoring backup from $BACKUP_INDEX to $RESTORE_INDEX"

  # Restore mappings
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump \
    --input=/tmp/backup/$BACKUP_INDEX-mappings.json \
    --output=https://$ELASTIC_USER:$ELASTIC_PASSWORD@$ELASTIC_HOST/$RESTORE_INDEX \
    --type=mapping \
    --insecure

  if [ $? -eq 0 ]; then
    echo "Mappings for $RESTORE_INDEX restored successfully."
  else
    echo "Failed to restore mappings for $RESTORE_INDEX."
  fi

  # Restore data
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump \
    --input=/tmp/backup/$BACKUP_INDEX-data.json \
    --output=https://$ELASTIC_USER:$ELASTIC_PASSWORD@$ELASTIC_HOST/$RESTORE_INDEX \
    --type=data \
    --insecure

  if [ $? -eq 0 ]; then
    echo "Data for $RESTORE_INDEX restored successfully."
  else
    echo "Failed to restore data for $RESTORE_INDEX."
  fi

  echo ""
done
