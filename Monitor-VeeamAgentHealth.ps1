<# 
.SYNOPSIS
    Monitor-VeeamAgentHealth

.DESCRIPTION
    Monitor-VeeamAgentHealth is a PowerShell script that checks the local computer's Veeam Agent health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-VeeamAgentHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.Name -like "Veeam*" -and $_.StartType -eq "Automatic") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) Veeam Agent services (with StartType=Automatic) discovered and running"
}
else {
    Write-Output "0 Veeam Agent services (with StartType=Automatic) discovered"
}