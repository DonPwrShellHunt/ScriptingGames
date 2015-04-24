Function Get-Laptop {
    Param(
        [string]$computer = 'localhost'
    )
# Design points - extra points for writing a simple function that
# only returns a Boolean value
    $islaptop = $false
# According to Ed Wilson, (5/15/2010) multiple checks are a good idea
# since at times both of these approaches "simply do not work".
# First check SystemEnclosure for Laptop/Notebook/SubNotebook
    if ( Get-WmiObject -Class Win32_SystemEnclosure -ComputerName $computer |
        Where-Object { $_.ChassisTypes -eq 9 -or $_.ChassisTypes -eq 10 -or $_.ChassisTypes -eq 14} )
        { $islaptop = $true }
# Next, check to see if battery information is available
    if ( Get-WmiObject -Class Win32_Battery -ComputerName $computer )
        { $islaptop = $true }
# return only a boolean value -per design point
    $islaptop
}

# call function Get-Laptop to determine if computer is a laptop or desktop
# event scenario stated report should include computer name,
# and whether it is a desktop or laptop machine.
# PowerShell best practices indicate that objects are preferable to text as output

if ( Get-Laptop ) { $machineType = "laptop" }
Else { $machineType = "desktop" }
$data = @{
    'ComputerName' = $env:COMPUTERNAME;
    'MachineType'  = $machineType
}
$obj = New-Object -Type PSObject -Property $data
Write-Output $obj