
FROM mcr.microsoft.com/powershell:latest AS build
ARG ACCESS_TOKEN
ARG RELEASE_TAG_ID
ARG ASSET_NAME
ARG GITHUB_REPO_URI
ARG EXTRA_FILES_BASE64

WORKDIR /src

COPY ["script.ps1", "script.ps1"]

RUN pwsh ./script.ps1 -githubAccessToken "${ACCESS_TOKEN}" -releaseTagId "${RELEASE_TAG_ID}" -assetName "${ASSET_NAME}" -githubUri "${GITHUB_REPO_URI}" -extraFilesBase64 "${EXTRA_FILES_BASE64}"

