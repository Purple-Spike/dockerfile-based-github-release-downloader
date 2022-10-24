# uri https://github.com/Purple-Spike/public-web-app
# releaseId 3200335278
# asset PublicApi.zip
# access token 

# pwsh ./script.ps1 -githubAccessToken "" releaseTagId 3200335278 -assetName "PublicApi.zip" -githubUri "https://github.com/Purple-Spike/public-web-app"

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

$downloadedFilePath = "./downloads/" + $assetName 
$extractedPath = "./extracted"

#Set-GitHubConfiguration -DisableTelemetry

$release = Get-GitHubRelease -Uri $githubUri -Tag $releaseTagId

$assets = $release | Get-GitHubReleaseAsset 

$selectedAsset = $assets | Where-Object -Property "name" -Match -Value $assetName

Write-Host $selectedAsset

# # Download the asset
# Get-GitHubReleaseAsset -Uri $githubUri -Release $releaseId -Asset $assetName -Path $downloadedFilePath

# # Extract the asset to a known directory
# Expand-Archive -Path $downloadedFilePath -DestinationPath $extractedPath
