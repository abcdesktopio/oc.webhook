#!/bin/bash

# need
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

docker pull $REGISTRY/$image
