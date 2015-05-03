Function Add-Privilege {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$True)]
        [string]$AccountName,
        [parameter(Mandatory=$True)]
        [Privileges[]]$Privilege
    )
    #region Main

    #region ConvertSIDStringToSID
    Write-Verbose "Gathering SID information"
    $AccountSID = ([System.Security.Principal.NTAccount]$AccountName).Translate([System.Security.Principal.SecurityIdentifier])
    $SID = [intptr]::Zero
    [void][PoshPrivilege]::ConvertStringSidToSid($AccountSID, [ref]$SID)
    #endregion ConvertSIDStringToSID

    #region LsaOpenPolicy
    $Computer = New-Object LSA_UNICODE_STRING
    $Computer.Buffer = $env:COMPUTERNAME
    $Computer.Length = ($Computer.buffer.length * [System.Text.UnicodeEncoding]::CharSize)
    $Computer.MaximumLength = (($Computer.buffer.length+1) * [System.Text.UnicodeEncoding]::CharSize)
    $PolicyHandle = [intptr]::Zero
    $ObjectAttributes = New-Object LSA_OBJECT_ATTRIBUTES
    [uint32]$Access = [LSA_AccessPolicy]::POLICY_CREATE_ACCOUNT -BOR [LSA_AccessPolicy]::POLICY_LOOKUP_NAMES
    Write-Verbose "Opening policy handle"
    $NTStatus = [PoshPrivilege]::LsaOpenPolicy(
        [ref]$Computer,
        [ref]$ObjectAttributes,
        $Access,
        [ref]$PolicyHandle
    )

    #region winErrorCode
    If ($NTStatus -ne 0) {
        $Win32ErrorCode = [PoshPrivilege]::LsaNtStatusToWinError($return)
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
        $_UserRights.Length = ($_UserRights.Buffer.length * [System.Text.UnicodeEncoding]::CharSize)
        $_UserRights.MaximumLength = ($_UserRights.Length + [System.Text.UnicodeEncoding]::CharSize)
        $UserRights = New-Object LSA_UNICODE_STRING[] -ArgumentList 1
        $UserRights[0] = $_UserRights
        Write-Verbose "Adding Privilege: $($PrivilegeName.ToString())"
        $NTStatus = [PoshPrivilege]::LsaAddAccountRights(
            $PolicyHandle,
            $SID,
            $UserRights,
            1    
        )

        #region winErrorCode
        If ($NTStatus -ne 0) {
            $Win32ErrorCode = [PoshPrivilege]::LsaNtStatusToWinError($return)
            Write-Warning $(New-Object System.ComponentModel.Win32Exception -ArgumentList $Win32ErrorCode)
            BREAK
        }
    }
    #endregion winErrorCode

    #endregion LsaAddAccountRights

    #region Cleanup
    
    #region Close Policy Handle
    [void][PoshPrivilege]::LsaClose($PolicyHandle)
    #endregion Close Policy Handle

    #region Free SID
    [void][PoshPrivilege]::FreeSid($SID)
    #endregion Free SID

    #region Clear Pointers
    [void][System.Runtime.InteropServices.Marshal]::FreeHGlobal($SID)
    #endregion Clear Pointers

    #endregion Cleanup
    #endregion Main
}