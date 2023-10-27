

#!/bin/bash



# Set variables

CONFIGMAP_NAME=${CONFIGMAP_NAME}

NAMESPACE=${NAMESPACE}

CONFIG_FILE=${CONFIG_FILE}

BUCKET_SIZE=${BUCKET_SIZE}



# Get the current config map for the pod

kubectl get configmap -n $NAMESPACE $CONFIGMAP_NAME -o yaml > $CONFIG_FILE



# Increase the server_names_hash_bucket_size in the config file

sed -i "s/server_names_hash_bucket_size.*$/server_names_hash_bucket_size $BUCKET_SIZE;/" $CONFIG_FILE



# Delete the original config map

kubectl delete configmap $CONFIGMAP_NAME -n $NAMESPACE



# Create a new config map with the updated config file

kubectl create configmap $CONFIGMAP_NAME --from-file=$CONFIG_FILE -n $NAMESPACE --dry-run=client -o yaml | kubectl replace -f -



echo "Nginx pod configuration updated successfully."