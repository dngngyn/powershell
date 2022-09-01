<# 
.SYNOPSIS
    Monitor-QuestChangeAuditorServerHealth

.DESCRIPTION
    Monitor-QuestChangeAuditorServerHealth is a PowerShell script that checks the local computer's Quest Change Auditor Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-QuestChangeAuditorServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.Name -like "ChangeAuditor.Coordinator") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) Quest Change Auditor Server services discovered and running"
}
else {
    Write-Output "0 Quest Change Auditor Server services discovered"
}