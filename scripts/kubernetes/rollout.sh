#!/bin/bash
kubectl rollout restart daemonset $daemonset -n $NAMESPACE
