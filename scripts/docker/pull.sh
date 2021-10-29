#!/bin/bash

# need
# kubectl
# docker

if [ -z $image ]; then
	echo 'image not set'
	exit 1
fi 

if [ -z $REGISTRY ]; then
	echo "pulling image $image"
else
	image=$REGISTRY/$image
	echo "pulling image $image"
fi

echo "docker pull $image"
docker pull $image
