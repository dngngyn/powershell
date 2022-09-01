<# 
.SYNOPSIS
    Monitor-DellOpenManageVirtualDisks

.DESCRIPTION
    Monitor-DellOpenManageVirtualDisks is a PowerShell script that checks the local computer's Dell Open Manage Virtual Disks.

.AUTHOR
    Duong Nguyen
    Special thanks to Shane Wright for his help

.EXAMPLE
    .\Monitor-DellOpenManageVirtualDisks
    
#>

$ProgressPreference = 'SilentlyContinue'

# Virtual Disks
try {
    $OMReport = omreport storage vdisk
}
catch {
    $scriptError = "omreport command failed: $($_.Exception.Message)"
    Exit
}

$virtualDisks = @()

$OMReport = omreport storage vdisk

$temp = $null

switch -regex ($OMReport) {
    '^ID\s+:' {
        if ($temp) {
            $virtualDisks += $temp
        }
        $temp = New-Object PSObject
    }
    "^(?<variable>[\w\s]+):\s+(?<value>.*)" {
        $temp | Add-Member -MemberType NoteProperty -Name $matches.variable.trim() -Value $matches.value.trim()
    }
}

if ($temp) {
    $virtualDisks += $temp
}

$virtualDiskCounter = ($virtualDisks | Where-Object { $_.Status -ne "OK" } | Measure-Object).Count

if (($virtualDiskCounter) -ge 1) {
    Write-Output "Virtual Disks error. Please investigate"
    Write-Output $virtualDisks
}
else {
    Write-Output "Virtual Disks is OK"
}