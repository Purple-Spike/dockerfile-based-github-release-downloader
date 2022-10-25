
FROM mcr.microsoft.com/powershell:latest AS build
ARG ACCESS_TOKEN
ARG RELEASE_TAG_ID
ARG ASSET_NAME
ARG GITHUB_REPO_URI

WORKDIR /src

COPY ["script.ps1", "script.ps1"]

#RUN pwsh ./script.ps1 -githubAccessToken "${ACCESS_TOKEN}" -releaseTagId "${RELEASE_TAG_ID}" -assetName "${ASSET_NAME}" -githubUri "${GITHUB_REPO_URI}"
RUN pwsh ./script.ps1 -githubAccessToken "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" -releaseTagId "3317584461" -assetName "PublicWebClient.zip" -githubUri "https://github.com/Purple-Spike/public-web-app"

