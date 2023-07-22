<# 
.SYNOPSIS
    Monitor-IISServerHealth

.DESCRIPTION
    Monitor-IISServerHealth is a PowerShell script that checks the local computer's IIS Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-IISServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$IISWebsites = @()

$IISWebsites += Get-Website | Where-Object serverAutoStart -eq $true

if ($IISWebsites) {
    foreach ($IISWebsite in $IISWebsites) {
        if ($IISWebsite.State -ne "Started") {
            Write-Output "$($IISWebsite.Name) is not running"
        }
    }
    Write-Output "$($IISWebsite.Count) IIS websites (with serverAutoStart=True) discovered and running"
}
else {
    Write-Output "0 IIS websites (with serverAutoStart=True) discovered"
}