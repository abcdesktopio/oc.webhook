#!/bin/bash

# set default value
DOCKERD_PORT=2375

# list abcdesktop compute nodes
KUBE_NODE=$(kubectl get nodes -l abcdesktoptype=worker  --no-headers -o custom-columns=":metadata.name" ) 
SERVERS=($(echo "$KUBE_NODE" | tr ' ' '\n'))

if [ -z $SERVERS ];  then
	echo "kubectl get nodes -l abcdesktoptype=worker is empty"
	exit 1
fi

for server in "${SERVERS[@]}";
do
	echo "Cleaning $server:$DOCKERD_PORT"
        docker -H $server:$DOCKERD_PORT  rmi `docker -H $server:$DOCKERD_PORT  images -q --filter "dangling=true"` 2>/dev/null
done

exit 0
