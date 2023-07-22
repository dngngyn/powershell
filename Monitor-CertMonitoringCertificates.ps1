<# 
.SYNOPSIS
    Monitor-CertMonitoringCertificates

.DESCRIPTION
    Monitor-CertMonitoringCertificates is a PowerShell script that checks the Local Computer\CertMonitoring for expiring and expired certificates.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Monitor-CertMonitoringCertificates
    
#>

$certificates = Get-ChildItem -Path Cert:\LocalMachine\CertMonitoring

$expiredCertificates = $certificates | Where-Object NotAfter -lt (Get-Date).AddDays(90)

if ($expiredCertificates.Count -eq 0) {
    $message = "OK"
}
else {
    $results = $expiredCertificates | ForEach-Object { ($_.Subject -replace '.*CN=([^,]+).*', '$1') + ":" + $_.Thumbprint + ":" + ($_.NotAfter - (Get-Date)).TotalDays.ToString('0') }
    $message = $results -join "`r`n"
}

Write-Output "$message"