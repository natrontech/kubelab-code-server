# Use linuxserver/code-server as the base image
FROM linuxserver/code-server:4.18.0-ls180

# 1. Custom Favicon: Replace the favicon
COPY favicon.ico /app/code-server/src/browser/media/favicon.ico

# add user sudo kubelab-agent with UUID 1001 and GID 1001 to sudoers and home directory /config
RUN useradd -u 1001 -U -d /config -s /bin/false kubelab-agent && \
    usermod -G users kubelab-agent && \
    usermod -a -G kubelab-agent kubelab-agent && \
    usermod -a -G sudo kubelab-agent && \
    echo "kubelab-agent ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# replace abc with kubelab-agent in /etc/s6-overlay/s6-rc.d/init-code-server/run, /usr/local/bin/install-extension, /etc/s6-overlay/s6-rc.d/svc-code-server/run
RUN sed -i 's/abc/kubelab-agent/g' /etc/s6-overlay/s6-rc.d/init-code-server/run
RUN sed -i 's/abc/kubelab-agent/g' /usr/local/bin/install-extension
RUN sed -i 's/abc/kubelab-agent/g' /etc/s6-overlay/s6-rc.d/svc-code-server/run

# add --disable-workspace-trust to the exec of /etc/s6-overlay/s6-rc.d/svc-code-server/run
RUN sed -i '/\/app\/code-server\/bin\/code-server/a \\\t\t\t\t--disable-workspace-trust true \\' /etc/s6-overlay/s6-rc.d/svc-code-server/run

# install kubernetes vs code extension
RUN /app/code-server/bin/code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools --extensions-dir /config/extensions

# Installing kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Installing helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x ./get_helm.sh && \
    ./get_helm.sh && \
    rm ./get_helm.sh

# Installing kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv ./kustomize /usr/local/bin/kustomize

# Autocompletion for kubectl
RUN echo 'source <(kubectl completion bash)' >>/config/.bashrc
RUN echo 'alias k=kubectl' >>/config/.bashrc

# Autocompletion for helm
RUN echo 'source <(helm completion bash)' >>/config/.bashrc

RUN echo 'export PS1="\[\033[01;34m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "' >> /config/.bashrc