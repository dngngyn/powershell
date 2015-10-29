# Duong's Office 365 PoSH Connector
# Version 1.0
# Created by: Duong Nguyen
# Last modified: October 29th, 2015

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Duong's Office 365 PoSH Connector"
$form.Size = New-Object System.Drawing.Size(384,200)
$form.StartPosition = "CenterScreen"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(70,120)
$OKButton.Size = New-Object System.Drawing.Size(122,23)
$OKButton.Text = "Create PoSH Session"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(192,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(348,20)
$label1.Text = "Office 365 Admin Username: (e.g. user@company.onmicrosoft.com)"
$form.Controls.Add($label1)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(348,20)
$form.Controls.Add($textBox)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,70)
$label2.Size = New-Object System.Drawing.Size(348,20)
$label2.Text = "Office 365 Admin Password:"
$form.Controls.Add($label2)

$textBox2 = New-Object System.Windows.Forms.MaskedTextBox
$textBox2.PasswordChar = "*"
$textBox2.Location = New-Object System.Drawing.Point(10,90)
$textBox2.Size = New-Object System.Drawing.Size(348,20)
$form.Controls.Add($textBox2)

$form.Topmost = $True

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $username = $textBox.Text
    $plainPassword = $textBox2.Text
    $securePassword = $plainPassword | ConvertTo-SecureString -AsPlainText -Force
    $UserCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securePassword
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
    Import-PSSession $Session
}