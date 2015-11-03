Function Remove-Privilege {
    <#
        .SYNOPSIS
            Removes a specified privilege for a user or group

        .DESCRIPTION
            Removes a specified privilege for a user or group. This will remain until
            re-added using Add-Privilege or a policy is refreshed.

        .PARAMETER AccountName            
            The user or group which will have the privilege removed.
        
        .PARAMETER Privilege            
            Specific privilege/s to remove from the local machine
        
        .NOTES
            Name: Remove-Privilege
            Author: Boe Prox
            Version History:
                1.0 - Initial Version

        .EXAMPLE
        Remove-Privilege -AccountName Domain\SomeUser -Privilege SeBackupPrivilege

        Description
        -----------
        Removes the SeBackupPrivilege privilege for Domain\SomeUser on the local machine
        
    #>
    [cmdletbinding(
        SupportsShouldProcess = $True
    )]
    Param (
        [parameter(Mandatory=$True)]
        [string]$AccountName,
        [parameter(Mandatory=$True)]
        [Privileges[]]$Privilege
    )
    #No point going through everything if just using -WhatIf
    If ($PSCmdlet.ShouldProcess($AccountName,"Remove Privilege(s): $($Privilege -join ', ')")) {
        #region SID Information
        Write-Verbose "Gathering SID information"
        $AccountSID = ([System.Security.Principal.NTAccount]$AccountName).Translate([System.Security.Principal.SecurityIdentifier])
        $ByteBuffer = New-Object Byte[] -ArgumentList $AccountSID.BinaryLength
        $AccountSID.GetBinaryForm($ByteBuffer,0)
        $SIDPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($AccountSID.BinaryLength)
        [System.Runtime.InteropServices.Marshal]::Copy(
            $ByteBuffer, 
            0, 
            $SIDPtr, 
            $AccountSID.BinaryLength
        )
        #endregion SID Information

        #region LsaOpenPolicy
        $Computer = New-Object LSA_UNICODE_STRING
        $Computer.Buffer = $env:COMPUTERNAME
        $Computer.Length = ($Computer.buffer.length * [System.Text.UnicodeEncoding]::CharSize)
        $Computer.MaximumLength = (($Computer.buffer.length+1) * [System.Text.UnicodeEncoding]::CharSize)
        $PolicyHandle = [intptr]::Zero
        $ObjectAttributes = New-Object LSA_OBJECT_ATTRIBUTES
        [uint32]$Access = [LSA_AccessPolicy]::POLICY_CREATE_ACCOUNT -BOR [LSA_AccessPolicy]::POLICY_LOOKUP_NAMES
        Write-Verbose "Opening policy handle"
        $NTStatus = [PoShPrivilege]::LsaOpenPolicy(
            [ref]$Computer,
            [ref]$ObjectAttributes,
            $Access,
            [ref]$PolicyHandle
        )

        #region winErrorCode
        If ($NTStatus -ne 0) {
            $Win32ErrorCode = [PoShPrivilege]::LsaNtStatusToWinError($return)
            Write-Warning $(New-Object System.ComponentModel.Win32Exception -ArgumentList $Win32ErrorCode)
            BREAK
        }
        #endregion winErrorCode
        #endregion LsaOpenPolicy

        #region LsaAddAccountRights
        ForEach ($Priv in $Privilege) {
            $PrivilegeName = [privileges]::$Priv
            $_UserRights = New-Object LSA_UNICODE_STRING
            $_UserRights.Buffer = $Priv.ToString()
            #SF edts: replaced the two below lines to fix the buffer size
            $_UserRights.Length = ($_UserRights.Buffer.length * [System.Text.UnicodeEncoding]::CharSize)
            $_UserRights.MaximumLength = ($_UserRights.Length + [System.Text.UnicodeEncoding]::CharSize)
            $UserRights = New-Object LSA_UNICODE_STRING[] -ArgumentList 1
            $UserRights[0] = $_UserRights
           Write-Verbose "Removing Privilege: $($PrivilegeName.ToString())"
            $NTStatus = [PoShPrivilege]::LsaRemoveAccountRights(
                $PolicyHandle,
                $SIDPtr,
                $false, #SF edit: originally was true which would delete all privs and the account
                $UserRights,
                1    
            )

            #region winErrorCode
            If ($NTStatus -ne 0) {
                $Win32ErrorCode = [PoShPrivilege]::LsaNtStatusToWinError($return) 
                Write-Warning $(New-Object System.ComponentModel.Win32Exception -ArgumentList $Win32ErrorCode)
                BREAK
            }
        }
        #endregion winErrorCode

        #endregion LsaAddAccountRights

        #region Cleanup
    
        #region Close Policy Handle
        Write-Verbose "Closing policy handle"
        [void][PoShPrivilege]::LsaClose($PolicyHandle)
        #endregion Close Policy Handle

        #region Clear Pointers
        Write-Verbose "Clearing SID pointers"
        [void][System.Runtime.InteropServices.Marshal]::FreeHGlobal($SIDPtr)
        #endregion Clear Pointers

        #endregion Cleanup
    }
}