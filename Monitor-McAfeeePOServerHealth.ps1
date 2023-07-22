<# 
.SYNOPSIS
    Monitor-McAfeeePOServerHealth

.DESCRIPTION
    Monitor-McAfeeePOServerHealth is a PowerShell script that checks the local computer's McAfee ePO Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-McAfeeePOServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.Name -like "MCAFEEAPACHESRV" -or $_.Name -like "MCAFEEEVENTPARSERSRV" -or $_.Name -like "MCAFEETOMCATSRV5100" -and $_.StartType -eq "Automatic") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) McAfee ePO Server services (with StartType=Automatic) discovered and running"
}
else {
    Write-Output "0 McAfee ePO Server services (with StartType=Automatic) discovered"
}