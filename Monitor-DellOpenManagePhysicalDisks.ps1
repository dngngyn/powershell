<# 
.SYNOPSIS
    Monitor-DellOpenManagePhysicalDisks

.DESCRIPTION
    Monitor-DellOpenManagePhysicalDisks is a PowerShell script that checks the local computer's Dell Open Manage Physical Disks.

.AUTHOR
    Duong Nguyen
    Special thanks to Shane Wright for his help

.EXAMPLE
    .\Monitor-DellOpenManagePhysicalDisks
    
#>

$ProgressPreference = 'SilentlyContinue'

# Physical Disks
try {
    $OMReport = omreport storage pdisk controller=0
}
catch {
    $scriptError = "omreport command failed: $($_.Exception.Message)"
    Exit
}

$controllerIDs = omreport storage controller | Select-String '^ID\s+:' | ForEach-Object { $_ -replace 'ID\s+: ', '' }

$controllerIDs | ForEach-Object {
    $OMReport = omreport storage pdisk controller=$_
    $physicalDisks = @()
    $temp = $null
    switch -regex ($OMReport) {
        '^ID\s+:' {
            if ($temp) {
                $physicalDisks += $temp
            }
            $temp = New-Object PSObject
        }
        "^(?<variable>[\w\s]+):\s+(?<value>.*)" {
            $temp | Add-Member -MemberType NoteProperty -Name $matches.variable.trim() -Value $matches.value.trim()
        }
    }
    if ($temp) {
        $physicalDisks += $temp
    }
}

$physicalDiskCounter = ($physicalDisks | Where-Object { $_.Status -ne "OK" } | Measure-Object).Count

if (($physicalDiskCounter) -ge 1) {
    Write-Output "Physical Disks error. Please investigate"
    Write-Output $virtualDisks
}
else {
    Write-Output "Physical Disks is OK"
}