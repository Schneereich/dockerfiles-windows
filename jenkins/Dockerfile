# escape=`
FROM openjdk:8u232-windowsservercore-1809 AS jenkins-base

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV JENKINS_HOME="C:\data"

VOLUME ${JENKINS_HOME}

EXPOSE 8080 50000
WORKDIR C:\jenkins
ENTRYPOINT java -jar C:\jenkins\jenkins.war

COPY jenkins.war .


FROM jenkins-base
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG GIT_PATH="C:\git"
ARG DOCKER_PATH="C:\docker"

WORKDIR ${GIT_PATH}
COPY --from=schneereich/git:2.23.0-nanoserver-1809 ${GIT_PATH} .

WORKDIR ${DOCKER_PATH}
COPY --from=schneereich/docker-cli:19.03.1-nanoserver-1809 ${DOCKER_PATH} .

RUN $env:PATH = 'C:\docker;' + 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH; `
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

# docker build -t schneereich/jenkins:2.190.1_git-2.23.0_docker-19.03.1-ce_servercore-1809 .
# docker build -t vmw2kdocker:5000/ge/jenkins:2.190.1_git-2.23.0_docker-19.03.1-ce_servercore-1809 .
