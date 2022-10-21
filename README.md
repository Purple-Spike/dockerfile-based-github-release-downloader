# Purpose
The purpose of this repo is to download assets from a GitHub Release and extract them to a local folder. 


# Ok, but why?
A lot of static web app hosting providers (Azure Static Web Apps, DigitalOcean Static Site, etc) don't let you upload individual files. You have to use their build system that downloads the code and runs a build inside its system for the deployment. If you want to separate the build from the release, you have to build something to download the pre-built code and just upload that.

# How is this repo intended to be used?
This repo was created to be used to deploy DigitalOcean Static Sites.

1. The Dockerfile should be run by DigitalOcean build
1. The Dockerfile downloads a zip file from a given GitHub Release, then extracts the files


