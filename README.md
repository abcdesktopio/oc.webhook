# oc.webhook

[webhookd service](https://github.com/ncarlier/webhookd) is a service developped by from Nicolas Carlier.
abcdesktop add bash scripts to provide an out of band management service. 
This service update application images and abcdesktop services using bash script endpoint.
The goal of this service, is to expose management script API for gitlab, github or from a simple curl command outside abcdesktop service


## Webhookd source code 
* webhook source from webhookd https://github.com/ncarlier/webhookd

### Webhookd author 
[Nicolas Carlier](https://github.com/ncarlier)

## abcdesktop management scripts

All scripts use filter to the default kubernetes namespace `abcdeskop`

### client usage
``` 
# oc.webhook service ip address or fqdn 
# change this value with your own
SERVER=SERVER_IP_ADD

# http or https
# change this value with your own
PROTOCOL=http

# DEFAULT TCP PORT
# change this value with your own
PORT=8090

# set value as
# change this value with your own
# AUTH="-u USERNAME:PASSWORD"

# get version
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/

# get node
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/node
#
# return "kubectl get nodes -o json" command


# get services
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/service
#
# return "kubectl get services -n $NAMESPACE -o json"


# get daemonset 
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/daemonset
#
# return kubectl get daemonset -n $NAMESPACE -o json


# pull new image
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/pull?image=abcdesktopio/2048.d:dev
#
# pull a new image on each node 
# run docker pull command on each worker node
# return


# remove "dangling=true" image
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/image-clean
# 
# remove "dangling=true" docker images on each worker node
# this request can take a while


#
# run rollout for all daemonset 
# return values
#
#
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/rollout
#
# run "kubectl rollout restart daemonset $daemonset -n $NAMESPACE" command
#


#
# run rollout for a daemonset liek daemonset-nginx
# curl -v $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/rollout?daemonset=daemonset-nginx
# return

# run rollout status for daemonset
curl $AUTH -XPOST $PROTOCOL://$SERVER:$PORT/kubernetes/rollout-status
#
# return value
# Waiting for daemon set "daemonset-nginx" rollout to finish: 0 out of X new pods have been updated...
# Waiting for daemon set "daemonset-pyos" rollout to finish: 0 out of X new pods have been updated...
```


## Endpoints


| Endpoint `/kubernetes`                | Description           | Command                         |
|------------------------------------|-----------------------|---------------------------------|
| /kubernetes/node                   | list kubernetes nodes | `kubectl get nodes -o json -n abcdesktop`      |
| /kubernetes/daemonset              | list kubernetes daemonset  | `kubectl get daemonset -o json -n abcdesktop`      |
| /kubernetes/pod                    | list kubernetes pods  | `kubectl get pod   -o json -n abcdesktop`      |
| /kubernetes/rollout                | rollout kubernetes DaemonSet `daemonset-nginx` and `daemonset-nginx`  | `kubectl rollout restart daemonset -n abcdesktop`      |
| /kubernetes/rollout?daemonset=XXX | rollout a kubernetes daemonset  | `kubectl rollout restart daemonset $daemonset -n abcdesktop` |
| /kubernetes/pull?image=xxxx  | pull a docker image on each node | get nodes list with `kubectl get nodes -l abcdesktoptype=worker` then  `docker -H $server:$DOCKERD_PORT pull $image` |
| /kubernetes/image-clean | remove docker image `"dangling=true"` on each node | get nodes list with `kubectl get nodes -l abcdesktoptype=worker` then run `docker -H $server:$DOCKERD_PORT  rmi` with result of `docker -H $server:$DOCKERD_PORT  images -q --filter "dangling=true"` |




| Endpoint `/docker`                   | Description           | Command                         |
|------------------------------------|-----------------------|---------------------------------|
| /docker/pull?image=xxxx     | pull a docker image on the current node | `docker pull $image` |
| /docker/image-clean         |  remove docker image `"dangling=true"` on the current node | run `docker rmi` with result of `docker images -q --filter "dangling=true"` command |



## Build command for docker mode

This Dockerfile add commands like kublet and docker to the webhookd image.

```
# clone repos
git clone https://github.com/abcdesktopio/oc.webhook.git

# docker build
docker build  -t abcdesktopio/oc.webhookd  .
```

## docker-compose.yaml file

Complete the default `docker-compose.yaml` 

```
version: "3.5"

services:
  webhookd:
    hostname: webhookd
    image: abcdesktopio/webhookd
    container_name: webhookd
    restart: always
    ports:
    - "8090:8080"
    environment:
    - WHD_HOOK_LOG_OUTPUT=true
    - WHD_SCRIPTS=/scripts
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /etc/kubernetes:/etc/kubernetes:ro
```


### Example with an .htpasswd 

```
version: "3.5"

services:
  webhookd:
    hostname: webhookd
    image: abcdesktopio/webhookd:latest
    container_name: webhookd
    restart: always
    ports:
    - "8090:8080"
    environment:
    - WHD_PASSWD_FILE=/.htpasswd 
    - WHD_HOOK_LOG_OUTPUT=true
    - WHD_SCRIPTS=/scripts
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /etc/kubernetes:/etc/kubernetes:ro
    - ./.htpasswd:/.htpasswd:ro
```

You must define htpasswd, or github webhook secret, or gitlab secret, but DOT not expose endpoint whithout autentification and without TLS.


