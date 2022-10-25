param (
    [string]$githubAccessToken,
    [string]$githubUri,
    [Int64]$releaseTagId,
    [string]$assetName
)

Write-Host "Starting..."

if ($releaseTagId -lt 1) {
    throw 'Release Id is required'
}
if ([string]::IsNullOrWhiteSpace($githubUri)) {
    throw 'GitHub Uri Id is required'
}
if ([string]::IsNullOrWhiteSpace($assetName)) {
    throw 'Asset Name is required'
}
if ([string]::IsNullOrWhiteSpace($githubAccessToken)) {
    throw 'GitHub Access Token is required'
}

Write-Host "Installing PowerShell for GitHub module"
Install-Module -Name PowerShellForGitHub -AcceptLicense -Force

Write-Host "Setting Up GitHub Authentication"
$githubAccessTokenSecure = ($githubAccessToken | ConvertTo-SecureString -AsPlainText -Force)

$githubCreds = New-Object System.Management.Automation.PSCredential "username is ignored", $githubAccessTokenSecure
Set-GitHubAuthentication -Credential $githubCreds

Write-Host "Authentication Setup"

#clear these out now that they're no longer needed
$githubAccessTokenSecure = $null
$githubCreds = $null
$githubAccessToken = $null 

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

Write-Host "Loading GitHub Release from URI $githubUri and Tag $releaseTagId"

$release = Get-GitHubRelease -Uri $githubUri -Tag $releaseTagId

$assets = $release | Get-GitHubReleaseAsset 

Write-Host "Loading release asset named $assetName"

$selectedAsset = $assets | Where-Object -Property "name" -Match -Value $assetName

$downloadedAsset = $selectedAsset | Get-GitHubReleaseAsset -Path $downloadedDir -Force

# Extract the asset to a known directory
Expand-Archive -Path $downloadedAsset -DestinationPath $extractedDir
