FROM jenkins/jenkins:2.462.1-lts

USER root

RUN groupadd -g 999 docker || true \
  && usermod -aG docker jenkins

# Instalación de dependencias necesarias
RUN apt-get update && apt-get install -y \
  lsb-release \
  sudo \
  curl \
  apt-transport-https \
  gnupg \
  ca-certificates

# Configuración e instalación de Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg \
  && echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y docker-ce-cli

# Instalación de Google Cloud SDK (gcloud)
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
  | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  # && apt-get update && apt-get install -y google-cloud-sdk
  && apt-get update && apt-get install -y google-cloud-cli \
  google-cloud-cli-gke-gcloud-auth-plugin

# Instalación de kubectl v1.31.0
RUN curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && rm kubectl

# Instalación de Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# USER jenkins
