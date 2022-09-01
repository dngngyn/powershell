<# 
.SYNOPSIS
    Monitor-MicrosoftSQLServerHealth

.DESCRIPTION
    Monitor-MicrosoftSQLServerHealth is a PowerShell script that checks the local computer's Microsoft SQL Server health.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-MicrosoftSQLServerHealth
    
#>

$ProgressPreference = 'SilentlyContinue'

$instanceDetails = @()

$instanceDetails += Get-Service -ComputerName $env:COMPUTERNAME | Where-Object { ($_.name -like "MSSQL$*" -or $_.name -like "MSSQLSERVER" -or $_.name -like "SQL Server (*" -and $_.StartType -eq "Automatic") }

#Add exclusions
$instanceExclusions = @(
    #@{ComputerName = "SERVERNAME"; ServiceName = "MSSQLSERVER" }
)

$instanceNotRunningCounter = 0

if ($instanceDetails) {
    foreach ($instanceDetail in $instanceDetails) {
        if (($instanceDetail.Status -ne "Running") -and ($instanceDetail.ComputerName -ne $instanceExclusions.ComputerName) -and ($instanceDetail.ServiceName -ne $instanceExclusions.ServiceName)) {
            Write-Output "$($instanceDetail.Name) is not running"
            $instanceNotRunningCounter++
        }
    }
    if ($instanceNotRunningCounter -eq 0) {
        Write-Output "$($instanceDetails.Count) Microsoft SQL Server instances (with StartType=Automatic) discovered and running"
    }
}
else {
    Write-Output "0 Microsoft SQL Server instances (with StartType=Automatic) discovered"
}