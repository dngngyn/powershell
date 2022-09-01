<# 
.SYNOPSIS
    Monitor-MicrosoftSCCMServerHealth

.DESCRIPTION
    Monitor-MicrosoftSCCMServerHealth is a PowerShell script that checks the local computer's Microsoft SCCM Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-MicrosoftSCCMServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.Name -like "SMS_*" -and $_.StartType -eq "Automatic") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) Microsoft SCCM Server services discovered and running"
}
else {
    Write-Output "0 Microsoft SCCM Server services discovered"
}