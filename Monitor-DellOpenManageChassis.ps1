<# 
.SYNOPSIS
    Monitor-DellOpenManageChassis

.DESCRIPTION
    Monitor-DellOpenManageChassis is a PowerShell script that checks the local computer's Dell Open Manage Chassis.

.AUTHOR
    Duong Nguyen
    Special thanks to Shane Wright for his help

.EXAMPLE
    .\Monitor-DellOpenManageChassis
    
#>

$ProgressPreference = 'SilentlyContinue'

# Chassis
try {
    $OMReport = omreport chassis -fmt xml | Out-String
    $OMReport = [xml]$OMReport
}
catch {
    $scriptError = "omreport command failed: $($_.Exception.Message)"
    Exit
}

$chassisCounter = 0

$list = $OMReport.oma.parent | Get-Member -MemberType Property

$list.name | ForEach-Object {
    if (($OMReport.oma.parent.$_.computedobjstatus.strval -ne "OK") -and (($OMReport.oma.parent.$_.computedobjstatus))) {
        Write-Output "$_ is $($OMReport.oma.parent.$_.computedobjstatus.strval). Please investigate"
        $chassisCounter++
    }
}

if ($chassisCounter -eq 0) {
    Write-Output "Main System Chassis is OK"
}