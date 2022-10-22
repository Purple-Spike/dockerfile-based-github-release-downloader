
FROM mcr.microsoft.com/powershell:latest AS build

WORKDIR /src

COPY ["script.ps1", "script.ps1"]

RUN pwsh ./script.ps1
