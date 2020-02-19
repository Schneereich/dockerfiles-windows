# escape=`
# source: https://github.com/microsoft/dotnet-framework-docker/blob/master/4.8/runtime/windowsservercore-ltsc2019/Dockerfile

ARG WINDOWS_PATCH="20191210"
FROM mcr.microsoft.com/dotnet/framework/runtime:3.5-${WINDOWS_PATCH}-windowsservercore-ltsc2019

# Install .NET 4.8
RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe `
    && .\dotnet-framework-installer.exe /q `
    && del .\dotnet-framework-installer.exe `
    && powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

# Apply latest patch
RUN curl -fSLo patch.msu http://download.windowsupdate.com/c/msdownload/update/software/updt/2020/01/windows10.0-kb4534131-x64-ndp48_c52c7f486cc74de9a0813ed50dde31a87594ce5d.msu `
    && mkdir patch `
    && expand patch.msu patch -F:* `
    && del /F /Q patch.msu `
    && DISM /Online /Quiet /Add-Package /PackagePath:C:\patch\windows10.0-kb4534131-x64-ndp48.cab `
    && rmdir /S /Q patch

# ngen .NET Fx
ENV COMPLUS_NGenProtectedProcess_FeatureEnabled 0
RUN \Windows\Microsoft.NET\Framework64\v4.0.30319\ngen update `
    && \Windows\Microsoft.NET\Framework\v4.0.30319\ngen update

# docker build -t schneereich/dotnet-framework:3.5-4.8-servercore-1809 .