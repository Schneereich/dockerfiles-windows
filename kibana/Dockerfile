# source: https://github.com/sixeyed/diamol/blob/master/images/kibana/windows/Dockerfile
ARG KIBANA_VERSION="7.6.2"

FROM mcr.microsoft.com/windows/nanoserver:1809 as download
ARG KIBANA_VERSION

# https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.6.2-windows-x86_64.zip

RUN curl -o kibana.zip https://artifacts.elastic.co/downloads/kibana/kibana-oss-%KIBANA_VERSION%-windows-x86_64.zip
RUN md C:\\kibana-%KIBANA_VERSION%-windows-x86_64 && \
    tar -xzf kibana.zip

WORKDIR /kibana-${KIBANA_VERSION}-windows-x86_64
RUN del /Q node\\node.exe

FROM schneereich/node:10.19.0-nanoserver-1809
ARG KIBANA_VERSION

EXPOSE 5601
ENV KIBANA_HOME="/usr/share/kibana" 

WORKDIR /usr/share/kibana
COPY --from=download /kibana-${KIBANA_VERSION}-windows-x86_64/ .
COPY kibana.bat bin/
COPY kibana.yml config/

USER ContainerAdministrator
CMD ["bin\\kibana.bat"]