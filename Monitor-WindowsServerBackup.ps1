<# 
.SYNOPSIS
    Monitor-WindowsServerBackup

.DESCRIPTION
    Monitor-WindowsServerBackup is a PowerShell script that checks the local computer's Windows Server Backup status.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-WindowsServerBackup
    
#>

try {
    $summary = Get-WBSummary
    $currentJob = Get-WBJob
}
catch {
    Write-Output "WindowsServerBackup PowerShell Module not loaded: $($_.Exception.Message)"
    Exit
}

if (!(Get-WBPolicy)) {
    Write-Output "No backup policy found. Windows Server Backup is installed but not configured"
}
else {
    $failedBackups = Invoke-Command {
        if ($currentJob.JobState -eq 'Running' -and $currentJob.StartTime -lt (Get-Date).AddHours(-23)) {
            "Backup has been running for over 23 hours. Backup started at $($currentJob.StartTime)"
        }
        if ($summary.LastBackupResultHR -ne '0') {
            "Backup has completed with error code $($summary.LastBackupResultHR). Last backup started at $($summary.LastBackupTime)"
        }
        if ($summary.LastSuccessfulBackupTime -lt $($(Get-Date).AddHours(-48))) {
            "No successful backup for the last 48 hours"
        }
    }
         
    if ($failedBackups) {
        Write-Output "Failed backups found. Please check diagnostic information"
        Write-Output ($failedBackups, $Summary | Out-String)
    }
    else {
        Write-Output "Healthy. No failed backups found"
        Write-Output ($failedBackups, $Summary | Out-String)
    }
}