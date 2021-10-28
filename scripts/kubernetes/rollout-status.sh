#!/bin/bash

# list abcdesktop compute nodes
KUBE_DAEMONSETS=$(kubectl get daemonset --no-headers -o custom-columns=":metadata.name" -n $NAMESPACE)
DAEMONSETS=($(echo "$KUBE_DAEMONSETS" | tr ' ' '\n'))

if [ -z $DAEMONSETS ];  then
	echo "kubectl get daemonset is empty"
	exit 1
fi

for daemonset in "${DAEMONSETS[@]}";
do
	kubectl rollout status daemonset $daemonset --watch=false -n $NAMESPACE
done
