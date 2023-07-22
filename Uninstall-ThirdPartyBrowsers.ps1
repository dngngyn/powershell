<# 
.SYNOPSIS
    Uninstall-ThirdPartyBrowsers

.DESCRIPTION
    Uninstall-ThirdPartyBrowsers is a PowerShell script that silently installs Microsoft Edge Chromium, disables Microsoft Internet Explorer 11, and silently uninstalls popular third party browsers, from the local computer.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\Uninstall-ThirdPartyBrowsers
    
#>

$legacyEdge = Test-Path -Path "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe" -PathType Leaf

$chromiumEdge = Test-Path -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -PathType Leaf

if ($legacyEdge -ne $true) {
    Write-Output "Microsoft Edge Legacy not found."
}
else {
    Write-Output "Microsoft Edge Legacy is OK."
}

if ($chromiumEdge -ne $true) {
    Write-Output "Microsoft Edge Chromium not found."
    #Downloading and installing Microsoft Edge (64-bit)
    Write-Output "Downloading Microsoft Edge Chromium (64-bit)"
    #Latest MSI as of June 1, 2023. Update with the download link from: https://www.microsoft.com/en-us/edge/business/download?form=MA13FJ
    Invoke-WebRequest -Uri "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/55759d14-099c-4334-abb8-129e589bc264/MicrosoftEdgeEnterpriseX64.msi" -OutFile $env:TEMP\MicrosoftEdgeEnterpriseX64.msi
    Write-Output "Installing Microsoft Edge Chromium (64-bit)"
    $arg = @(
        "/qn"
    )
    $process = Start-Process "$env:TEMP\MicrosoftEdgeEnterpriseX64.msi" -ArgumentList $arg -PassThru
    $process.WaitForExit()
    $chromiumEdge = Test-Path -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -PathType Leaf
    if ($chromiumEdge -eq $true) {
        Write-Output "Microsoft Edge Chromium is OK. Disabling Internet Explorer 11"
        Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online -NoRestart
    }
    else {
        Write-Output "Microsoft Edge Chromium status is not OK. Exiting script"
        Exit
    }
}
else {
    Write-Output "Microsoft Edge Chromium is OK. Disabling Internet Explorer 11"
    Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online -NoRestart
}

#$browsers = @('Google Chrome\b.*','^Mozilla Firefox\b.*','^Opera Stable\b.*')
#Opera removed silent uninstall switch: https://forums.opera.com/topic/52484/solved-silent-uninstall-is-no-longer-working/6?_=1641329792724&lang=en-US
$browsers = @('Google Chrome\b.*', '^Mozilla Firefox\b.*')

$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString

$installed += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString

foreach ($install in $installed) {
    if ($install.DisplayName -match ($browsers -join '|')) {
        if ($install.UninstallString -like "msiexec*") {
            $arguments = (($install.UninstallString -split ' ')[1] -replace '/I', '/X ') + ' /q'
            Write-Output "Running msiexec $arguments"
            Start-Process msiexec.exe -ArgumentList $arguments -Wait
        }
        else {
            $uninstallCommand = (($install.UninstallString -split '\"')[1])
            $uninstallArguments = (($install.UninstallString -split '\"')[2]) + ' -ms'
            Write-Output "Running $uninstallCommand $uninstallArguments"
            Start-Process $uninstallCommand -ArgumentList $uninstallArguments -Wait
        }
    }
}