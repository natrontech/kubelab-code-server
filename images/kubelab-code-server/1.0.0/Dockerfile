# Use linuxserver/code-server as the base image
FROM linuxserver/code-server:4.18.0-ls180

# 1. Custom Favicon: Replace the favicon
COPY favicon.ico /app/code-server/src/browser/media/favicon.ico

# 2. Trusted Extensions: Install trusted extensions (replace with the extensions you trust)
RUN /app/code-server/bin/code-server --install-extension author.extension-name
