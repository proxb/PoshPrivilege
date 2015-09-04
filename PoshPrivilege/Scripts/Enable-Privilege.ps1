Function Enable-Privilege {
    <#
        .SYNOPSIS
            Enables specific privilege or privileges on the current process.

        .DESCRIPTION
            Enables specific privilege or privileges on the current process.
        
        .PARAMETER Privilege            
            Specific privilege/s to enable on the current process
        
        .NOTES
            Name: Enable-Privilege
            Author: Boe Prox
            Version History:
                1.0 - Initial Version

        .EXAMPLE
        Enable-Privilege -Privilege SeBackupPrivilege

        Description
        -----------
        Enables the SeBackupPrivilege on the existing process

        .EXAMPLE
        Enable-Privilege -Privilege SeBackupPrivilege, SeRestorePrivilege, SeTakeOwnershipPrivilege

        Description
        -----------
        Enables the SeBackupPrivilege,  SeRestorePrivilege and SeTakeOwnershipPrivilege on the existing process
        
    #>
    [cmdletbinding(
        SupportsShouldProcess = $True
    )]
    Param (
        [parameter(Mandatory = $True)]
        [Privileges[]]$Privilege
    )    
    If ($PSCmdlet.ShouldProcess("Process ID: $PID", "Enable Privilege(s): $($Privilege -join ', ')")) {
        #region Constants
        $SE_PRIVILEGE_ENABLED = 0x00000002
        $SE_PRIVILEGE_DISABLED = 0x00000000
        $TOKEN_QUERY = 0x00000008
        $TOKEN_ADJUST_PRIVILEGES = 0x00000020
        #endregion Constants

        $TokenPriv = New-Object TokPriv1Luid
        $HandleToken = [intptr]::Zero
        $TokenPriv.Count = 1
        $TokenPriv.Attr = $SE_PRIVILEGE_ENABLED
    
        #Open the process token
        $Return = [PoshPrivilege]::OpenProcessToken(
            [PoshPrivilege]::GetCurrentProcess(),
            ($TOKEN_QUERY -BOR $TOKEN_ADJUST_PRIVILEGES), 
            [ref]$HandleToken
        )    
        If (-NOT $Return) {
            Write-Warning "Unable to open process token! Aborting!"
            Break
        }
        ForEach ($Priv in $Privilege) {
            $PrivValue = $Null
            $TokenPriv.Luid = 0
            #Lookup privilege value
            $Return = [PoshPrivilege]::LookupPrivilegeValue($Null, $Priv, [ref]$PrivValue)             
            If ($Return) {
                $TokenPriv.Luid = $PrivValue
                #Adjust the process privilege value                
                $return = [PoshPrivilege]::AdjustTokenPrivileges(
                    $HandleToken, 
                    $False, 
                    [ref]$TokenPriv, 
                    [System.Runtime.InteropServices.Marshal]::SizeOf($TokenPriv), 
                    [IntPtr]::Zero, 
                    [IntPtr]::Zero
                )
                If (-NOT $Return) {
                    Write-Warning "Unable to enable privilege <$priv>! "
                }
            }
        }
    }
}