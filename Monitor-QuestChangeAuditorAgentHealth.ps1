<# 
.SYNOPSIS
    Monitor-QuestChangeAuditorAgentHealth

.DESCRIPTION
    Monitor-QuestChangeAuditorAgentHealth is a PowerShell script that checks the local computer's Quest Change Auditor Agent health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-QuestChangeAuditorAgentHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$serviceDetails = @()

$serviceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.Name -like "NPSrvHost") }

if ($serviceDetails) {
    foreach ($serviceDetail in $serviceDetails) {
        if ($serviceDetail.Status -ne "Running") {
            Write-Output "$($serviceDetail.Name) is not running"
        }
    }
    Write-Output "$($serviceDetails.Count) Quest Change Auditor Agent services discovered and running"
}
else {
    Write-Output "0 Quest Change Auditor Agent services discovered"
}