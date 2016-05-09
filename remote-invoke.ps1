# N.B. The argument passed to -scriptBlock must be enclosed in curly braces { }
# For example:
# &/Paths/To/File/remote-invoke.ps1 -machine MyServer -scriptBlock {
#     &C:\CommandToRun.cmd
# }

param (
    [string]$machine = $(throw "-machine is required."),
    [ScriptBlock]$scriptBlock = $(throw "-scriptBlock is required.")
)

#TODO: Pass this in as parameters
$pass = convertto-securestring "mypassword" -asplaintext -force
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "mydomain\myuser",$pass

$remoteSession = New-PSSession -ComputerName $machine -credential $mycred
Invoke-Command -Session $remoteSession -ScriptBlock $scriptBlock
$remoteLastExitCode = Invoke-Command -Session $remoteSession -ScriptBlock { $LastExitCode }
Remove-PSSession -Session $remoteSession

exit $remoteLastExitCode