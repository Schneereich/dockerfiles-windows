# escape=`
# global variables
ARG WINDOWS_PATCH="KB4538461"
ARG GIT_PATH="C:\git"

# source: https://github.com/sixeyed/dockerfiles-windows/blob/master/git/windowsservercore/ltsc2019/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH} AS installer
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG GIT_VERSION="2.23.0"
ARG GIT_RELEASE_NUMBER="1"
ARG GIT_DOWNLOAD_SHA256="8f65208f92c0b4c3ae4c0cf02d4b5f6791d539cd1a07b2df62b7116467724735"
ARG GIT_PATH

# RUN Write-Host "Downloading Git version: ${env:GIT_VERSION}, release: ${env:GIT_RELEASE_NUMBER}"; `
# 	  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
#     Invoke-WebRequest -OutFile git.zip -Uri "https://github.com/git-for-windows/git/releases/download/v${env:GIT_VERSION}.windows.${env:GIT_RELEASE_NUMBER}/MinGit-${env:GIT_VERSION}.${env:GIT_RELEASE_NUMBER}-64-bit.zip"
#     Invoke-WebRequest -OutFile git.zip -Uri "https://github.com/git-for-windows/git/releases/download/v${env:GIT_VERSION}.windows.${env:GIT_RELEASE_NUMBER}/MinGit-${env:GIT_VERSION}-64-bit.zip"
COPY MinGit-${GIT_VERSION}-64-bit.zip git.zip

RUN if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_DOWNLOAD_SHA256) {exit 1}; `
	Expand-Archive -Path git.zip -DestinationPath ${env:GIT_PATH}; `
	Remove-Item git.zip -Force

FROM mcr.microsoft.com/windows/nanoserver:1809-${WINDOWS_PATCH}

ARG GIT_PATH

WORKDIR ${GIT_PATH}
COPY --from=installer ${GIT_PATH} .

USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%GIT_PATH%\cmd;%GIT_PATH%\mingw64\bin;%GIT_PATH%\usr\bin"
USER ContainerUser

# docker build -t schneereich/git:2.23.0-nanoserver-1809 .