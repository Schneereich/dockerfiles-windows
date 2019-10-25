# escape=`
# global variables
ARG WINDOWS_PATCH="KB4512578"
ARG DOCKER_PATH="C:\docker"

# source: https://github.com/sixeyed/dockerfiles-windows/blob/master/docker-cli/windowsservercore/ltsc2019/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH} AS installer
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG INNOEXTRACT_VERSION="1.8"
ARG INNOEXTRACT_MD5="01efb1f497f9afef630e32097d8a1e33"
ARG DOCKER_TOOLBOX_VERSION="19.03.1"
ARG DOCKER_TOOLBOX_SHA256="bf39c167f1c2bfc18651c5ebcbc2deb044119dc527f49f3b0c1012c4fe8e9768"
ARG COMPOSE_VERSION="1.24.1"
ARG COMPOSE_SHA256="60d449ad3dbb2db10a9dd1ac7cbd00ffcb86a286109f94c743a46ba660b036e2"
ARG DOCKER_PATH

# https://constexpr.org/innoextract/files/innoextract-${INNOEXTRACT_VERSION}-windows.zip
COPY innoextract-${INNOEXTRACT_VERSION}-windows.zip innoextract.zip
RUN if ((Get-FileHash innoextract.zip -Algorithm md5).Hash -ne ${env:INNOEXTRACT_MD5}) {exit 1}; `
	Expand-Archive -Path innoextract.zip -DestinationPath C:\ ; `
    Remove-Item -Path innoextract.zip

COPY DockerToolbox-${DOCKER_TOOLBOX_VERSION}.exe DockerToolbox.exe
RUN if ((Get-FileHash DockerToolbox.exe -Algorithm sha256).Hash -ne ${env:DOCKER_TOOLBOX_SHA256}) {exit 1}; `
	Start-Process -FilePath C:\innoextract.exe `
    -ArgumentList 'DockerToolbox.exe' `
    -NoNewWindow -Wait; `
    New-Item ${env:DOCKER_PATH} -ItemType Directory; `
    Move-Item 'C:\app\docker.exe' ${env:DOCKER_PATH}; `
    Remove-Item -Path DockerToolbox.exe; `
    Remove-Item -Force -Recurse C:\app

# https://github.com/docker/toolbox/releases/download/v${DOCKER_TOOLBOX_VERSION}/DockerToolbox-${DOCKER_TOOLBOX_VERSION}.exe
# https://github.com/docker/toolbox/releases/download/v${DOCKER_TOOLBOX_VERSION}/sha256sum.txt
COPY docker-compose-Windows-x86_64.exe docker-compose.exe
RUN if ((Get-FileHash docker-compose.exe -Algorithm sha256).Hash -ne ${env:COMPOSE_SHA256}) {exit 1}; `
	Move-Item 'docker-compose.exe' ${env:DOCKER_PATH}


FROM mcr.microsoft.com/windows/nanoserver:1809-${WINDOWS_PATCH}

ARG WINDOWS_PATCH
ARG DOCKER_PATH

COPY --from=installer ${DOCKER_PATH} ${DOCKER_PATH}
# Workaround: https://github.com/StefanScherer/dockerfiles-windows/tree/master/golang-issue-21867
COPY --from=installer C:/Windows/System32/netapi32.dll C:/Windows/System32/netapi32.dll

WORKDIR ${DOCKER_PATH}
CMD [ "docker.exe" ]

# docker build -t schneereich/docker-cli:19.03.1-nanoserver-1809 .