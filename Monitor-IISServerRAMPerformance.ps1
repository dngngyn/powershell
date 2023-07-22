<# 
.SYNOPSIS
    Monitor-IISServerRAMPerformance

.DESCRIPTION
    Monitor-IISServerRAMPerformance is a PowerShell script that checks the local computer's IIS Server RAM performance.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-IISServerRAMPerformance
    
#>

$ProgressPreference = 'SilentlyContinue'

$worker = @()

$worker += Get-WMIObject -ComputerName localhost -Namespace 'root\WebAdministration' -Class 'WorkerProcess' | Select-Object AppPoolName, @{n = 'RAM'; e = { [math]::round((Get-Process -Id $_.ProcessId -ComputerName $_.PSComputerName).WorkingSet / 1Mb) } }

$totalRAM = (Get-WMIObject -Computername localhost -Class win32_ComputerSystem | Select-Object -Expand TotalPhysicalMemory) / 1Mb

foreach ($workers in $worker) {
    if ($($workers.RAM) -gt ($totalRAM * 0.8)) {
        Write-Output "$($workers.AppPoolName) RAM utilization is over 80%! Please investigate"
    }
    else {
        Write-Output "$($workers.AppPoolName) discovered and running at $($workers.RAM) MB RAM utilization"
    }
}