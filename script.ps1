param (
    [string]$githubAccessToken,
    [string]$githubUri,
    [Int64]$releaseTagId,
    [string]$assetName,
    [string]$extraFilesBase64
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

if (-not [string]::IsNullOrWhiteSpace($extraFilesBase64)) {
    $extraFilesJson = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($extraFilesBase64))

    $extraFilesObj = $extraFilesJson | ConvertFrom-Json
    Write-Host "Creating extra files: $extraFilesObj"
    foreach ($extraFile in $extraFilesObj) {
        $outputContent = [System.Convert]::FromBase64String($extraFile.Base64Content)

        if ($extraFile.Type -eq "STRING") {
            $outputContent = [System.Text.Encoding]::ASCII.GetString($outputContent)
            Write-Host "Outputting STRING content: $outputContent"
        }

        $outputFileName = "$extractedDir/$($extraFile.FileName)";
        Write-Host "Writing Extra File: $outputFileName"
        Out-File -FilePath $outputFileName -InputObject $outputContent -Force
    }
}
else {
    Write-Host "No extra files to create"
}