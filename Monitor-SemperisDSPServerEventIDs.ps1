<# 
.SYNOPSIS
    Monitor-SemperisDSPServerEventID

.DESCRIPTION
    Monitor-SemperisDSPServerEventID is a PowerShell script that checks the local computer's Semperis DSP Server Event IDs.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-SemperisDSPServerEventID
    
#>

$SemperisDSPLog = Get-WinEvent -FilterHashtable @{
    LogName   = 'Semperis-DSP-Monitor/Operational'
    ID        = 40102, 40103, 40110, 40111, 40112
    StartTime = (Get-Date).AddDays(-1)
} -MaxEvents 100 -ErrorAction SilentlyContinue

if ($SemperisDSPLog) {
    Write-Output "$($SemperisDSPLog.Count) Semperis DSP Monitor error Event IDs discovered in the last 24 hours"
}
else {
    Write-Output "0 Semperis DSP Monitor error Event IDs discovered"
}