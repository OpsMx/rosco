
FROM registry.access.redhat.com/ubi8/ubi
MAINTAINER sig-platform@spinnaker.io
COPY rosco-web/build/install/rosco /opt/rosco
COPY rosco-web/config              /opt/rosco
COPY halconfig/packer              /opt/rosco/config/packer

WORKDIR /packer

RUN yum install -y java-11-openjdk-headless.x86_64 wget unzip curl git openssh-client && \
  wget https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip && \
  unzip packer_1.4.5_linux_amd64.zip && \
  rm packer_1.4.5_linux_amd64.zip

ENV PATH "/packer:$PATH"

# Install Helm 3
RUN wget https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 && \
  chmod +x get-helm-3 && \
  ./get-helm-3 && \
  rm get-helm-3 && \
  mv /usr/local/bin/helm /usr/local/bin/helm3

# Install Helm 2
RUN wget https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get && \
  chmod +x get && \
  ./get && \
  rm get

RUN mkdir kustomize && \
  curl -s -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz |\
  tar xvz -C kustomize/

ENV PATH "kustomize:$PATH"

RUN useradd spinnaker
RUN mkdir -p /opt/rosco/plugins
USER spinnaker
CMD ["/opt/rosco/bin/rosco"]
