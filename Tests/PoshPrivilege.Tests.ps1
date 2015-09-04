#handle PS2
if(-not $PSScriptRoot)
{
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
 
#Verbose output if this isn't master, or we are testing locally
$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master" -or -not $env:APPVEYOR_REPO_BRANCH)
{
    $Verbose.add("Verbose",$False)
}
 
$PSVersion = $PSVersionTable.PSVersion.Major
Switch ($PSVersion) {
    4 {Import-Module $PSScriptRoot\..\PoshPrivilege\PoshPrivilege -Force -ErrorAction SilentlyContinue}
    2 {Import-Module PoshPrivilege -Force -ErrorAction SilentlyContinue}
}
 
Describe "PoshPrivilege PS$PSVersion" {
    Context 'Strict mode' {
        Set-StrictMode -Version latest
        It 'should load all functions' {
            $Commands = @( Get-Command -CommandType Function -Module PoshPrivilege | Select -ExpandProperty Name)
            $Commands.count | Should be 5
            $Commands -contains "Add-Privilege"     | Should be $True
            $Commands -contains "Disable-Privilege" | Should be $True
            $Commands -contains "Enable-Privilege"  | Should be $True
            $Commands -contains "Get-Privilege"   | Should be $True
            $Commands -contains "Remove-Privilege"    | Should be $True
        }
        It 'should load all aliases' {
            $Commands = @( Get-Command -CommandType Alias -Module PoshPrivilege | Select -ExpandProperty Name)
            $Commands.count | Should be 5
            $Commands -contains "appv"     | Should be $True
            $Commands -contains "dppv" | Should be $True
            $Commands -contains "eppv"  | Should be $True
            $Commands -contains "gppv"   | Should be $True
            $Commands -contains "rppv"    | Should be $True           
        }
    }
}