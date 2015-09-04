Function Get-Privilege {
    <#
        .SYNOPSIS
            Gets all privileges on a local or remote system.

        .DESCRIPTION
            Gets the currently applied privileges or current user privileges.
        
        .PARAMETER Privilege            
            Specific privilege/s to view.

        .PARAMETER Computername
            View privileges on a remote system

        .PARAMETER CurrentUser
            View the currently applied privileges for the current user
        
        .NOTES
            Name: Get-Privilege
            Author: Boe Prox
            Version History:
                1.0 - Initial Version

        .EXAMPLE
            Get-Privilege

            Computername         Privilege                        Accounts
            ------------         ---------                        --------
            BOE-PC               SeAssignPrimaryTokenPrivilege    {IIS APPPOOL\.NET v4.5 Cl...
            BOE-PC               SeAuditPrivilege                 {IIS APPPOOL\.NET v4.5 Cl...
            BOE-PC               SeBackupPrivilege                {BUILTIN\Backup Operators...
            BOE-PC               SeBatchLogonRight                {BUILTIN\IIS_IUSRS, BUILT...
            BOE-PC               SeChangeNotifyPrivilege          {Window Manager\Window Ma...
            BOE-PC               SeCreateGlobalPrivilege          {NT AUTHORITY\SERVICE, BU...
            BOE-PC               SeCreatePagefilePrivilege        {BUILTIN\Administrators}
            BOE-PC               SeCreatePermanentPrivilege       {}
            BOE-PC               SeCreateSymbolicLinkPrivilege    {BUILTIN\Administrators}
            ...

            Description
            -----------
            Enables the SeBackupPrivilege on the existing process

        .EXAMPLE
            Get-Privilege -CurrentUser

            Privilege                        Description                              Enabled
            ---------                        -----------                              -------
            SeLockMemoryPrivilege            Lock pages in memory                     False
            SeIncreaseQuotaPrivilege         Adjust memory quotas for a process       False
            SeTcbPrivilege                   Act as part of the operating system      False
            SeSecurityPrivilege              Manage auditing and security log         False
            SeTakeOwnershipPrivilege         Take ownership of files or other objects False
            SeLoadDriverPrivilege            Load and unload device drivers           False
            SeSystemProfilePrivilege         Profile system performance               False
            SeSystemtimePrivilege            Change the system time                   False
            SeProfileSingleProcessPrivilege  Profile single process                   False
            SeIncreaseBasePriorityPrivilege  Increase scheduling priority             False
            SeCreatePagefilePrivilege        Create a pagefile                        False
            SeBackupPrivilege                Back up files and directories            False
            SeRestorePrivilege               Restore files and directories            False
            SeShutdownPrivilege              Shut down the system                     False
            SeDebugPrivilege                 Debug programs                           True
            SeSystemEnvironmentPrivilege     Modify firmware environment values       False
            SeChangeNotifyPrivilege          Bypass traverse checking                 True
            SeRemoteShutdownPrivilege        Force shutdown from a remote system      False
            SeUndockPrivilege                Remove computer from docking station     False
            SeManageVolumePrivilege          Perform volume maintenance tasks         False
            SeImpersonatePrivilege           Impersonate a client after authentica... True
            SeCreateGlobalPrivilege          Create global objects                    True
            SeIncreaseWorkingSetPrivilege    Increase a process working set           False
            SeTimeZonePrivilege              Change the time zone                     False
            SeCreateSymbolicLinkPrivilege    Create symbolic links                    False

            Description
            -----------
            Displays currently applied privileges for current user.

        .EXAMPLE
            Get-Privilege -Privilege SeDebugPrivilege

            Computername         Privilege                        Accounts
            ------------         ---------                        --------
            BOE-PC               SeDebugPrivilege                 {}

        Description
        -----------
        Shows all accounts/groups that have been given SeDebugPrivilege

        .OutputType
            PSPrivilege.Privilege
            PSPrivilege.CurrentUserPrivilege
    #>
    #REQUIRES -Version 3.0
    [OutputType('PSPrivilege.Privilege','PSPrivilege.CurrentUserPrivilege')]
    [cmdletbinding(
        DefaultParameterSetName = 'Default'
    )]
    Param (
        [parameter(ParameterSetName='Default')]
        [Privileges[]]$Privilege,
        [parameter(ParameterSetName='Default')]
        [string]$Computername = $Env:Computername  ,
        [parameter(ParameterSetName='CurrentUser')]
        [switch]$CurrentUser
    )
    Switch ($PSCmdlet.ParameterSetName) {
        'CurrentUser' {
            $Process = Get-Process -Id $PID
            $PROCESS_QUERY_INFORMATION = [ProcessAccessFlags]::QueryInformation

            $TOKEN_ALL_ACCESS = [System.Security.Principal.TokenAccessLevels]::AllAccess
            $hProcess = [PoShPrivilege]::OpenProcess(
                $PROCESS_QUERY_INFORMATION, 
                $True, 
                $Process.Id
            )
            Write-Debug "ProcessHandle: $($hProcess)"

            $hProcessToken = [intptr]::Zero
            [void][PoShPrivilege]::OpenProcessToken(
                $hProcess, 
                $TOKEN_ALL_ACCESS, 
                [ref]$hProcessToken
            )
            Write-Debug "ProcessToken: $($hProcessToken)"
            [void][PoShPrivilege]::CloseHandle($hProcess)

            [UInt32]$TokenPrivSize = 1000
            [IntPtr]$TokenPrivPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPrivSize)
            [uint32]$ReturnLength = 0
            [void][PoShPrivilege]::GetTokenInformation(
                $hProcessToken,
                [TOKEN_INFORMATION_CLASS]::TokenPrivileges,
                $TokenPrivPtr,
                $TokenPrivSize,
                [ref]$ReturnLength
            )

            $TokenPrivileges = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenPrivPtr, [Type][TOKEN_PRIVILEGES])
            [IntPtr]$PrivilegesBasePtr = [IntPtr](AddSignedIntAsUnsigned $TokenPrivPtr ([System.Runtime.InteropServices.Marshal]::OffsetOf(
                [Type][TOKEN_PRIVILEGES], "Privileges"
            )))
            $LuidAndAttributeSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][LUID_AND_ATTRIBUTES])
            for ($i=0; $i -lt $TokenPrivileges.PrivilegeCount; $i++) {
                $LuidAndAttributePtr = [IntPtr](AddSignedIntAsUnsigned $PrivilegesBasePtr ($LuidAndAttributeSize * $i))
                $LuidAndAttribute = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidAndAttributePtr, [Type][LUID_AND_ATTRIBUTES])
                [UInt32]$PrivilegeNameSize = 60
                $PrivilegeNamePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PrivilegeNameSize)
                $PLuid = $LuidAndAttributePtr
                [void][PoShPrivilege]::LookupPrivilegeNameW(
                    [IntPtr]::Zero, 
                    $PLuid, 
                    $PrivilegeNamePtr, 
                    [Ref]$PrivilegeNameSize
                )
                $PrivilegeName = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($PrivilegeNamePtr)
                $Enabled = $False
                If ($LuidAndAttribute.Attributes -ne 0) {
                    $Enabled = $True
                }
                $Object = [pscustomobject]@{
                    Computername = $env:COMPUTERNAME
                    Account = "{0}\{1}" -f ($env:USERDOMAIN, $env:USERNAME)
                    Privilege = $PrivilegeName
                    Description = GetPrivilegeDisplayName -Privilege $PrivilegeName
                    Enabled = $Enabled
                }
                $Object.pstypenames.insert(0,'PSPrivilege.CurrentUserPrivilege')
                $Object
            }
        }
        Default {
            If (-NOT $PSBoundParameters.ContainsKey('Privilege')) {
                $Privilege = [Privileges].GetEnumNames()
            }

            #region LsaOpenPolicy
            $Computer = New-Object LSA_UNICODE_STRING
            $Computer.Buffer = $Computername
            $Computer.Length = ($Computer.buffer.length * [System.Text.UnicodeEncoding]::CharSize)
            $Computer.MaximumLength = (($Computer.buffer.length+1) * [System.Text.UnicodeEncoding]::CharSize)
            $PolicyHandle = [intptr]::Zero
            $ObjectAttributes = New-Object LSA_OBJECT_ATTRIBUTES
            [uint32]$Access = [LSA_AccessPolicy]::POLICY_VIEW_LOCAL_INFORMATION -BOR [LSA_AccessPolicy]::POLICY_LOOKUP_NAMES
            Write-Verbose "Opening policy handle"
            [void][PoShPrivilege]::LsaOpenPolicy(
                [ref]$Computer,
                [ref]$ObjectAttributes,
                $Access,
                [ref]$PolicyHandle
            )
            #endregion LsaOpenPolicy

            #region LsaEnumerateAccountsWithUserRight
            ForEach ($Priv in $Privilege) {
                $UserRight = New-Object LSA_UNICODE_STRING
                $UserRight.Buffer = $Priv.ToString()
                $UserRight.Length = ($UserRight.Buffer.Length * [System.Text.UnicodeEncoding]::CharSize)
                $UserRight.MaximumLength = (($UserRight.buffer.length+1) * [System.Text.UnicodeEncoding]::CharSize)
                $EnumerationBuffer = [intptr]::Zero
                [uint32]$Count = 0 
                Write-Verbose "Gathering enumerating accounts with user right"               
                $NTStatus = [PoShPrivilege]::LsaEnumerateAccountsWithUserRight(
                    $PolicyHandle,
                    $UserRight,
                    [ref]$EnumerationBuffer,
                    [ref]$Count
                )
                $Accounts = New-Object System.Collections.Arraylist
                If ($NTStatus -eq 0) {
                    $LSAInfo = [intptr]::Zero
                    $StructSize = [System.Runtime.InteropServices.Marshal]::SizeOf([type][LSA_ENUMERATION_INFORMATION])    
                    Write-Debug "StructSize: $($StructSize)"
                    Write-Verbose "Gathering privilege information"
                    For ($i=0; $i -lt $Count; $i++) {
                        Write-Debug "Iteration: $($i)"
                        $EnumerationItem = [intptr]($EnumerationBuffer.ToInt64() + ([long]$StructSize*[long]$i))
                        $Sid = [System.Runtime.InteropServices.Marshal]::PtrToStructure(
                            $EnumerationItem,
                            [type][LSA_ENUMERATION_INFORMATION]
                        )
                        [string]$SIDString = [string]::Empty
                        [void][PoShPrivilege]::ConvertSidToStringSid($Sid.sid, [ref]$SIDString)
                        Try {
                            $Account = ([system.security.principal.securityidentifier]$SIDString).Translate([System.Security.Principal.NTAccount]).Value
                        } Catch {
                            $Account = $SIDString
                        }
                        [void]$Accounts.Add($Account)
                    }
                }  
                $Object = [pscustomobject]@{
                    Computername = $Computername
                    Privilege = $Priv.ToString()
                    Description = GetPrivilegeDisplayName -Privilege $Priv.ToString()
                    Accounts = $Accounts
                }
                $Object.pstypenames.insert(0,'PSPrivilege.Privilege')
                $Object
            }
            #endregion LsaEnumerateAccountsWithUserRight

            #region Close Policy Handle
            Write-Verbose "Closing policy handle"
            [void][PoShPrivilege]::LsaClose($PolicyHandle)
            $PolicyHandle = [intptr]::Zero
            #region Close Policy Handle
        }
    }
}