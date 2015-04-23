# Assumptions from Dr. Scripto
# You do not need to parameterize your script
# You can safely assume the SERVER1,SERVER2, etc, do not already exist in the domain
# DHCP scope is named 10.0.0.0 and the DHCP server name is 'DHCP1'
# MAC addresses of all Windows 2012 Server Core virtual machines are in C:\Mac.txt
# Local administrator account password is 'P@ssw0rd', same for domain\admin.
# Domain is 'Company.local'

#Requires -Version 3.0
#Requires -Module DHCPserver

$passwd = 'P@ssw0rd' | ConvertTo-SecureString -AsPlainText -Force
$localcred = New-Object -Type System.Management.Automation.PSCredential("\Administrator",$passwd)
$domaincred = New-Object -Type System.Management.Automation.PSCredential("Company\Admin",$passwd)

$v4leases = @(Get-DhcpServerv4Lease -ClientId (Get-Content -Path C:\Mac.txt) -ScopeId 10.0.0.0 -ComputerName DHCP1)

If ($v4leases.Count) {
  1..($v4leases.Count) | 
  
    select @{N='ComputerName';E={$v4leases[$_ -1].IPAddress}},@{N='NewName';E={"SERVER$_"}} |
  
    ForEach-Object -Process {
      $cn = $_.ComputerName
      Try {
        Add-Computer -DomainName Company.local -Force -Restart -ComputerName $cn -NewName $_.NewName -Credential $domaincred -LocalCredential $localcred -ErrorAction Stop
      } Catch {
        Write-Output "Failed to add $cn, $_"
      }
    }
} Else {'No Servers with MAC addresses found'}
