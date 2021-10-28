# oc.webhook

[webhookd service](https://github.com/ncarlier/webhookd) from Nicolas Carlier.
service update application images and abcdesktop services

## Source 
webhook source from webhookd https://github.com/ncarlier/webhookd

## author 
[Nicolas Carlier](https://github.com/ncarlier)

## Build command for docker mode

This Dockerfile add commands like kublet and docker to the webhookd image.

```
# clone repos
git clone https://github.com/abcdesktopio/oc.webhook.git

# docker build
docker build  -t abcdesktopio/oc.webhookd  .
```

## docker-compose.yaml file

Complete the default `docker-compose.yaml` to add htpasswd, auth token as need

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




