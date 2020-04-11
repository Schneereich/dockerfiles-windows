# escape=`

ARG WINDOWS_PATCH="KB4538461"

# Source: https://github.com/containous/traefik-library-image/blob/master/windows/1809/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG TRAEFIK_VERSION="2.2.0"
ARG TRAEFIK_DOWNLOAD_SHA256="9a794e395b7eba8d44118c4a1fb358fbf14abff3f5f5d264f46b1d6c243b9a5e"

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
    org.opencontainers.image.version="v2.2.0" `
    org.opencontainers.image.documentation="https://docs.traefik.io"

# docker build -t schneereich/traefik:2.2.0-servercore-1809 .