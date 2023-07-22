<# 
.SYNOPSIS
    Monitor-QuestRMADServerHealth

.DESCRIPTION
    Monitor-QuestRMADServerHealth is a PowerShell script that checks the local computer's Quest Recovery Manage for Active Directory Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-QuestRMADServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.name -like "RmadCloudStorage" -or $_.name -like "RecoveryMgrPortalAccess" -and $_.StartType -eq "Automatic") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) Quest RMAD Server services discovered and running"
}
else {
    Write-Output "0 Quest RMAD Server services discovered"
}