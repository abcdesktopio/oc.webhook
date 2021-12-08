#!/bin/bash

if [ -z $daemonset ]; then
	daemonset=$1
fi

if [ -z $daemonset ]; then
	echo 'daemonset not set use all'
	daemonset=""
fi 

kubectl rollout restart daemonset $daemonset -n $NAMESPACE
