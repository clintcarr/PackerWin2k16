Write-Host "Disabling Password Complexity"
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

$password = ConvertTo-SecureString -String "Qlik1234" -AsPlainText -Force
New-LocalUser qlik -Password $password -FullName "Qlik User" -AccountNeverExpires

Grant-Privilege -Identity $env:COMPUTERNAME\qlik -Privilege SeRemoteInteractiveLogonRight

Add-GroupMember -Name 'Remote Desktop Users' -Member $env:COMPUTERNAME\qlik
Add-GroupMember -Name 'Administrators' -Member $env:COMPUTERNAME\qlik