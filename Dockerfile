FROM ubuntu:20.04

ENV DEBCONF_FRONTEND noninteractive
ENV TERM linux
# set debconf to Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y  --no-install-recommends \
	apt-transport-https ca-certificates golang-1.16 curl jq  \
    && apt-get clean			\
    && rm -rf /var/lib/apt/lists/*

# install webhookd
# from ncarlier/webhookd 
#COPY install.sh /tmp
#RUN bash -x /tmp/install.sh		\ 
#    && mv /root/.local/bin/webhookd /usr/bin \
#    && apt-get clean			\
#    && rm -rf /var/lib/apt/lists/*

COPY webhookd /usr/bin/webhookd
COPY httpsig /usr/bin/httpsig

# install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN bash ./get-docker.sh              \
    && apt-get clean                    \
    && rm -rf /var/lib/apt/lists/*


# install Kubernetes
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y  --no-install-recommends \
        kubectl  \
    && apt-get clean                    \
    && rm -rf /var/lib/apt/lists/*

# use kubeconfig
ENV KUBECONFIG=/etc/kubernetes/admin.conf
ENV NAMESPACE=abcdesktop
ENV REGISTRY=abcdesktopio
ENV WHD_SCRIPTS=/scripts
# Maximum hook execution time in second, default is 10
# change to 10 min
ENV WHD_HOOK_TIMEOUT=600
COPY scripts /scripts

# Define entrypoint
CMD ["/usr/bin/webhookd"]
# 
