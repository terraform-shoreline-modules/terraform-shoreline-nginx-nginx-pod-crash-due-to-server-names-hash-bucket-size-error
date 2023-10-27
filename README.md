
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Nginx Pod Crash due to Server Names Hash Bucket Size Error.
---

This incident type refers to a situation where an nginx pod crashes after deployment due to the error message "[emerg] could not build the server_names_hash, you should increase server_names_hash_bucket_size: 64". This error occurs when the server_names_hash_bucket_size parameter in the nginx configuration file is set to a value that is too small to accommodate all the server names. As a result, nginx is unable to build the server names hash table, leading to a crash of the nginx pod. This incident can be resolved by increasing the server_names_hash_bucket_size parameter in the nginx configuration file to a power of two value that is sufficient to hold the longest server name.

### Parameters
```shell
export NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export BUCKET_SIZE="PLACEHOLDER"

export CONFIG_FILE="PLACEHOLDER"

export CONFIGMAP_NAME="PLACEHOLDER"
```

## Debug

### List all pods in the namespace where the incident occurred
```shell
kubectl get pods -n ${NAMESPACE}
```

### Describe the nginx pod to see its current status and events
```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

### Check the logs of the pod to see if there are any errors or warnings
```shell
kubectl logs ${POD_NAME} -n ${NAMESPACE}
```

### Check the nginx configuration file configmap to verify the server_names_hash_bucket_size value
```shell
kubectl get configmap ${CONFIGMAP_NAME} -o jsonpath='{.data.nginx\.conf}' | grep -o 'server_names_hash_bucket_size [0-9]\+;'
```

## Repair

### Increase the server_names_hash_bucket_size in the nginx configuration. This can be done by modifying the nginx.conf file or the configuration file for the specific pod that is crashing.
```shell


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


```