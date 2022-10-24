# uri https://github.com/Purple-Spike/public-web-app
# releaseId 3200335278
# asset PublicApi.zip
# access token 

# pwsh ./script.ps1 -githubAccessToken "" -releaseTagId 3200335278 -assetName "PublicApi.zip" -githubUri "https://github.com/Purple-Spike/public-web-app"

param (
    [string]$githubAccessToken,
    [string]$githubUri,
    [Int64]$releaseTagId,
    [string]$assetName
)

# Install-Module -Name PowerShellForGitHub

$githubAccessTokenSecure = ($githubAccessToken | ConvertTo-SecureString -AsPlainText -Force)

$githubCreds = New-Object System.Management.Automation.PSCredential "username is ignored", $githubAccessTokenSecure
Set-GitHubAuthentication -Credential $githubCreds

#clear these out now that they're no longer needed
$githubAccessTokenSecure = $null
$githubCreds = $null
$githubAccessToken = $null 

if ($releaseTagId -lt 1) {
    throw 'Release Id is required'
}
if ([string]::IsNullOrWhiteSpace($githubUri)) {
    throw 'GitHub Uri Id is required'
}
if ([string]::IsNullOrWhiteSpace($assetName)) {
    throw 'Asset Name is required'
}

$downloadedDir = "./downloads"
$extractedDir = "./extracted"

if (Test-Path $downloadedDir) {
    Remove-Item $downloadedDir -Force -Recurse
}

if (Test-Path $extractedDir) {
    Remove-Item $extractedDir -Force -Recurse
}

New-Item -Path $downloadedDir -ItemType Directory
New-Item -Path $extractedDir -ItemType Directory

$release = Get-GitHubRelease -Uri $githubUri -Tag $releaseTagId

$assets = $release | Get-GitHubReleaseAsset 

$selectedAsset = $assets | Where-Object -Property "name" -Match -Value $assetName

$downloadedAsset = $selectedAsset | Get-GitHubReleaseAsset -Path $downloadedDir -Force

# Extract the asset to a known directory
Expand-Archive -Path $downloadedAsset -DestinationPath $extractedDir
