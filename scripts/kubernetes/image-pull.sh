#!/bin/bash

# need
# kubectl
# docker

if [ -z $image ]; then
	image=$1
fi

if [ -z $image ]; then
	echo 'image not set'
	exit 1
fi 

if [ -z $REGISTRY ]; then
	echo 'registry not set'
	exit 1
fi



# set default value
DOCKERD_PORT=2375

# list abcdesktop compute nodes
KUBE_NODE=$(kubectl get nodes -l abcdesktoptype=worker  --no-headers -o custom-columns=":metadata.name")
SERVERS=($(echo "$KUBE_NODE" | tr ' ' '\n'))

if [ -z $SERVERS ];  then
	echo "kubectl get nodes -l abcdesktoptype=worker is empty"
	exit 1
fi

for server in "${SERVERS[@]}";
do
	echo "docker -H $server:$DOCKERD_PORT  pull $REGISTRY/$image"
        docker -H $server:$DOCKERD_PORT pull $REGISTRY/$image
done
