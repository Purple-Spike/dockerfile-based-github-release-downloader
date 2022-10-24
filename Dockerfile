
FROM mcr.microsoft.com/powershell:latest AS build
ENV ACCESS_TOKEN
ENV RELEASE_TAG_ID
ENV ASSET_NAME
ENV GITHUB_REPO_URI

WORKDIR /src

COPY ["script.ps1", "script.ps1"]

RUN pwsh ./script.ps1 -githubAccessToken "${ACCESS_TOKEN}" -releaseTagId "${RELEASE_TAG_ID}" -assetName "${ASSET_NAME}" -githubUri "${GITHUB_REPO_URI}"

