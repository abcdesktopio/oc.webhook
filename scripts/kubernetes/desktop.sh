#!/bin/bash
kubectl get pods -l type=x11server,domain=desktop -n $NAMESPACE -o json
