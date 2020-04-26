# escape=`
# docker build -t gogs:0.11.91-nanoserver-1809 .
# docker container run -d -p 3000:3000 --name=gogs -v U:\gogs\data:C:\data -v U:\gogs\repos:C:\gogs\repositories gogs:0.11.91-nanoserver-1809

# global variables
ARG WINDOWS_PATCH="KB4538461"
ARG GOGS_VERSION="0.11.91"
ARG GOGS_PATH="C:\gogs"
ARG GIT_PATH="C:\git"

### Git Download ###
# source: https://github.com/sixeyed/dockerfiles-windows/blob/master/git/windowsservercore/ltsc2019/Dockerfile
#         https://github.com/sixeyed/diamol/blob/master/images/gogs/windows/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH} AS git
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG 7ZIP_VERSION="1900"
RUN Invoke-WebRequest "http://7-zip.org/a/7z${env:7ZIP_VERSION}-x64.msi" -OutFile '7z.msi' -UseBasicParsing; `
    Start-Process msiexec.exe -ArgumentList '/i', '7z.msi', '/quiet', '/norestart' -NoNewWindow -Wait; `
    Remove-Item 7z.msi

ARG GIT_VERSION="2.26.2"
ARG GIT_RELEASE_NUMBER="1"
ARG GIT_DOWNLOAD_SHA256="dd36f76a815b993165e67ad3cbc8f5b2976e5757a0c808a4a92fb72d1000e1c8"
ARG GIT_PATH

RUN Write-Host "Downloading Git version: ${env:GIT_VERSION}, release: ${env:GIT_RELEASE_NUMBER}"; `
    Invoke-WebRequest -OutFile git.7z.exe -Uri "https://github.com/git-for-windows/git/releases/download/v${env:GIT_VERSION}.windows.${env:GIT_RELEASE_NUMBER}/PortableGit-${env:GIT_VERSION}-64-bit.7z.exe"; `
    if ((Get-FileHash git.7z.exe -Algorithm sha256).Hash -ne $env:GIT_DOWNLOAD_SHA256) {exit 1}; `
	& 'C:\Program Files\7-Zip\7z.exe' x -oC:\git .\git.7z.exe;

### Gogs Download ###
# source: https://github.com/sixeyed/dockerfiles-windows/blob/master/gogs/nanoserver/1809/Dockerfile
#         https://github.com/sixeyed/docker-on-windows/blob/second-edition/ch10/ch10-gogs/Dockerfile
FROM mcr.microsoft.com/windows/servercore:1809-${WINDOWS_PATCH} AS installer
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG GOGS_VERSION

RUN Write-Host "Downloading: ${env:GOGS_VERSION}"; `
	Invoke-WebRequest -Uri "https://dl.gogs.io/${env:GOGS_VERSION}/gogs_${env:GOGS_VERSION}_windows_amd64.zip" -OutFile 'gogs.zip'; `
	Write-Host 'Expanding Gogs...'; `
	Expand-Archive gogs.zip -DestinationPath C:\;

### Gogs Installation ###
FROM mcr.microsoft.com/windows/nanoserver:1809-${WINDOWS_PATCH}

ARG GOGS_VERSION
ARG GOGS_PATH
ARG GIT_PATH

ENV GOGS_VERSION=${GOGS_VERSION} `
    GOGS_PATH=${GOGS_PATH} `
    GIT_PATH=${GIT_PATH}

EXPOSE 3000
VOLUME C:\data C:\logs C:\repositories
CMD ["gogs", "web"]

USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%GIT_PATH%\cmd;%GIT_PATH%\mingw64\bin;%GIT_PATH%\usr\bin;"
USER ContainerUser

WORKDIR ${GIT_PATH}
COPY --from=git ${GIT_PATH} ${GIT_PATH}

WORKDIR ${GOGS_PATH}
COPY app.ini ./custom/conf/app.ini
COPY --from=installer ${GOGS_PATH} .