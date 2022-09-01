<# 
.SYNOPSIS
    ConnectWiseAutomate-EncodeScriptBlock

.DESCRIPTION
    ConnectWiseAutomate-EncodeScriptBlock is a PowerShell script that encodes your existing PowerShell script to a one-liner executable for ConnectWise Automate.
    Run the script, then paste your one-liner executable in ConnectWise Automate.

.AUTHOR
    Duong Nguyen

.EXAMPLE
    .\ConnectWiseAutomate-EncodeScriptBlock
    
#>

$scriptBlockToEncode = {
    #Paste your PowerShell script here
}

$scriptBlockToEncode2 = [scriptblock]::create($(($scriptBlockToEncode) -join "`r`n"))

#Install the PSMinifier Module, or the Compress-ScriptBlock command
$shrunkToString = ". " + ((Compress-ScriptBlock -scriptblock $scriptBlockToEncode2 -GZip) -replace '[\n\r\s]+', '')

"%windir%\System32\WindowsPowershell\v1.0\powershell.exe -noprofile -command `"$shrunkToString`"" | clip