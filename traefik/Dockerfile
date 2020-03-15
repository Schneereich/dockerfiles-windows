# escape=`

ARG WINDOWS_PATCH="KB4512578"

# Source: https://github.com/containous/traefik-library-image/blob/master/windows/1809/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG TRAEFIK_VERSION="2.1.6"
ARG TRAEFIK_DOWNLOAD_SHA256="8995ccacb2c313b5f4051544a8d2d709b2d1207e5f2736a8b45cf36780801f7f"

COPY traefik_v${TRAEFIK_VERSION}_windows_amd64.zip /traefik.zip
RUN if ((Get-FileHash "/traefik.zip" -Algorithm sha256).Hash -ne $env:TRAEFIK_DOWNLOAD_SHA256) {exit 1}; `
    Expand-Archive -Path "/traefik.zip" -DestinationPath "/" -Force; `
    Remove-Item "/traefik.zip" -Force

EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" `
    org.opencontainers.image.url="https://traefik.io" `
    org.opencontainers.image.title="Traefik" `
    org.opencontainers.image.description="A modern reverse-proxy" `
    org.opencontainers.image.version="v2.1.6" `
    org.opencontainers.image.documentation="https://docs.traefik.io"

# docker build -t schneereich/traefik:2.1.6-servercore-1809 .