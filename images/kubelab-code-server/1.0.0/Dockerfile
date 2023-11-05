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