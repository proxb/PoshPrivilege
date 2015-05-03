$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

#region Module Builder
$Domain = [AppDomain]::CurrentDomain
$DynAssembly = New-Object System.Reflection.AssemblyName('PrivilegeAssembly')
$AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run) # Only run in memory
$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('PrivilegeModule', $False)
#endregion Module Builder

#region Enums
#region LSA_AccessPolicy
$EnumBuilder = $ModuleBuilder.DefineEnum('LSA_AccessPolicy', 'Public', [uint32])
[void]$EnumBuilder.DefineLiteral('POLICY_AUDIT_LOG_ADMIN', [uint32] 0x00000200)
[void]$EnumBuilder.DefineLiteral('POLICY_CREATE_ACCOUNT', [uint32] 0x00000010)
[void]$EnumBuilder.DefineLiteral('POLICY_CREATE_PRIVILEGE', [uint32] 0x00000040)
[void]$EnumBuilder.DefineLiteral('POLICY_CREATE_SECRET', [uint32] 0x00000020)
[void]$EnumBuilder.DefineLiteral('POLICY_GET_PRIVATE_INFORMATION', [uint32] 0x00000004)
[void]$EnumBuilder.DefineLiteral('POLICY_LOOKUP_NAMES', [uint32] 0x00000800)
[void]$EnumBuilder.DefineLiteral('POLICY_NOTIFICATION', [uint32] 0x00001000)
[void]$EnumBuilder.DefineLiteral('POLICY_SERVER_ADMIN', [uint32] 0x00000400)
[void]$EnumBuilder.DefineLiteral('POLICY_SET_AUDIT_REQUIREMENTS', [uint32] 0x00000100)
[void]$EnumBuilder.DefineLiteral('POLICY_SET_DEFAULT_QUOTA_LIMITS', [uint32] 0x00000080)
[void]$EnumBuilder.DefineLiteral('POLICY_TRUST_ADMIN', [uint32] 0x00000008)
[void]$EnumBuilder.DefineLiteral('POLICY_VIEW_AUDIT_INFORMATION', [uint32] 0x00000002)
[void]$EnumBuilder.DefineLiteral('POLICY_VIEW_LOCAL_INFORMATION', [uint32] 0x00000001)
[void]$EnumBuilder.CreateType()
#endregion LSA_AccessPolicy
#region Privileges
$EnumBuilder = $ModuleBuilder.DefineEnum('Privileges', 'Public', [uint32])
[void]$EnumBuilder.DefineLiteral('SeAssignPrimaryTokenPrivilege',[uint32] 0x00000000)
[void]$EnumBuilder.DefineLiteral('SeAuditPrivilege',[uint32] 0x00000001)
[void]$EnumBuilder.DefineLiteral('SeBackupPrivilege',[uint32] 0x00000002)
[void]$EnumBuilder.DefineLiteral('SeBatchLogonRight',[uint32] 0x00000003)
[void]$EnumBuilder.DefineLiteral('SeChangeNotifyPrivilege',[uint32] 0x00000004)
[void]$EnumBuilder.DefineLiteral('SeCreateGlobalPrivilege',[uint32] 0x00000005)
[void]$EnumBuilder.DefineLiteral('SeCreatePagefilePrivilege',[uint32] 0x00000006)
[void]$EnumBuilder.DefineLiteral('SeCreatePermanentPrivilege',[uint32] 0x00000007)
[void]$EnumBuilder.DefineLiteral('SeCreateSymbolicLinkPrivilege',[uint32] 0x00000008)
[void]$EnumBuilder.DefineLiteral('SeCreateTokenPrivilege',[uint32] 0x00000009)
[void]$EnumBuilder.DefineLiteral('SeDebugPrivilege',[uint32] 0x0000000a)
[void]$EnumBuilder.DefineLiteral('SeImpersonatePrivilege',[uint32] 0x0000000b)
[void]$EnumBuilder.DefineLiteral('SeIncreaseBasePriorityPrivilege',[uint32] 0x0000000c)
[void]$EnumBuilder.DefineLiteral('SeIncreaseQuotaPrivilege',[uint32] 0x0000000d)
[void]$EnumBuilder.DefineLiteral('SeInteractiveLogonRight',[uint32] 0x0000000e)
[void]$EnumBuilder.DefineLiteral('SeLoadDriverPrivilege',[uint32] 0x0000000f)
[void]$EnumBuilder.DefineLiteral('SeLockMemoryPrivilege',[uint32] 0x00000010)
[void]$EnumBuilder.DefineLiteral('SeMachineAccountPrivilege',[uint32] 0x00000011)
[void]$EnumBuilder.DefineLiteral('SeManageVolumePrivilege',[uint32] 0x00000012)
[void]$EnumBuilder.DefineLiteral('SeNetworkLogonRight',[uint32] 0x00000013)
[void]$EnumBuilder.DefineLiteral('SeProfileSingleProcessPrivilege',[uint32] 0x00000014)
[void]$EnumBuilder.DefineLiteral('SeRemoteInteractiveLogonRight',[uint32] 0x00000015)
[void]$EnumBuilder.DefineLiteral('SeRemoteShutdownPrivilege',[uint32] 0x00000016)
[void]$EnumBuilder.DefineLiteral('SeRestorePrivilege',[uint32] 0x00000017)
[void]$EnumBuilder.DefineLiteral('SeSecurityPrivilege',[uint32] 0x00000018)
[void]$EnumBuilder.DefineLiteral('SeServiceLogonRight',[uint32] 0x00000019)
[void]$EnumBuilder.DefineLiteral('SeShutdownPrivilege',[uint32] 0x0000001a)
[void]$EnumBuilder.DefineLiteral('SeSystemEnvironmentPrivilege',[uint32] 0x0000001b)
[void]$EnumBuilder.DefineLiteral('SeSystemProfilePrivilege',[uint32] 0x0000001c)
[void]$EnumBuilder.DefineLiteral('SeSystemtimePrivilege',[uint32] 0x0000001d)
[void]$EnumBuilder.DefineLiteral('SeTakeOwnershipPrivilege',[uint32] 0x0000001e)
[void]$EnumBuilder.DefineLiteral('SeTcbPrivilege',[uint32] 0x0000001f)
[void]$EnumBuilder.DefineLiteral('SeTimeZonePrivilege',[uint32] 0x00000020)
[void]$EnumBuilder.DefineLiteral('SeUndockPrivilege',[uint32] 0x00000021)
[void]$EnumBuilder.DefineLiteral('SeDenyNetworkLogonRight',[uint32] 0x00000022)
[void]$EnumBuilder.DefineLiteral('SeDenyBatchLogonRight',[uint32] 0x00000023)
[void]$EnumBuilder.DefineLiteral('SeDenyServiceLogonRight',[uint32] 0x00000024)
[void]$EnumBuilder.DefineLiteral('SeDenyInteractiveLogonRight',[uint32] 0x00000025)
[void]$EnumBuilder.DefineLiteral('SeSyncAgentPrivilege',[uint32] 0x00000026)
[void]$EnumBuilder.DefineLiteral('SeEnableDelegationPrivilege',[uint32] 0x00000027)
[void]$EnumBuilder.DefineLiteral('SeDenyRemoteInteractiveLogonRight',[uint32] 0x00000028)
[void]$EnumBuilder.DefineLiteral('SeTrustedCredManAccessPrivilege',[uint32] 0x00000029)
[void]$EnumBuilder.DefineLiteral('SeIncreaseWorkingSetPrivilege',[uint32] 0x0000002a)
[void]$EnumBuilder.CreateType()
#endregion Privileges
#region TOKEN_INFORMATION_CLASS
$EnumBuilder = $ModuleBuilder.DefineEnum('TOKEN_INFORMATION_CLASS', 'Public', [uint32])
[void]$EnumBuilder.DefineLiteral('TokenUser ',[uint32] 0x00000001)
[void]$EnumBuilder.DefineLiteral('TokenGroups',[uint32] 0x00000002)
[void]$EnumBuilder.DefineLiteral('TokenPrivileges',[uint32] 0x00000003)
[void]$EnumBuilder.DefineLiteral('TokenOwner',[uint32] 0x00000004)
[void]$EnumBuilder.DefineLiteral('TokenPrimaryGroup',[uint32] 0x00000005)
[void]$EnumBuilder.DefineLiteral('TokenDefaultDacl',[uint32] 0x00000006)
[void]$EnumBuilder.DefineLiteral('TokenSource',[uint32] 0x00000007)
[void]$EnumBuilder.DefineLiteral('TokenType',[uint32] 0x00000008)
[void]$EnumBuilder.DefineLiteral('TokenImpersonationLevel',[uint32] 0x00000009)
[void]$EnumBuilder.DefineLiteral('TokenStatistics',[uint32] 0x0000000a)
[void]$EnumBuilder.DefineLiteral('TokenRestrictedSids',[uint32] 0x0000000b)
[void]$EnumBuilder.DefineLiteral('TokenSessionId',[uint32] 0x0000000c)
[void]$EnumBuilder.DefineLiteral('TokenGroupsAndPrivileges',[uint32] 0x0000000d)
[void]$EnumBuilder.DefineLiteral('TokenSessionReference',[uint32] 0x0000000e)
[void]$EnumBuilder.DefineLiteral('TokenSandBoxInert',[uint32] 0x0000000f)
[void]$EnumBuilder.DefineLiteral('TokenAuditPolicy',[uint32] 0x00000010)
[void]$EnumBuilder.DefineLiteral('TokenOrigin',[uint32] 0x00000011)
[void]$EnumBuilder.CreateType()
#endregion TOKEN_INFORMATION_CLASS
#region ProcessAccessFlags 
$EnumBuilder = $ModuleBuilder.DefineEnum('ProcessAccessFlags', 'Public', [uint32])
[void]$EnumBuilder.DefineLiteral('All', [uint32] 0x001F0FFF)
[void]$EnumBuilder.DefineLiteral('Terminate', [uint32] 0x00000001)
[void]$EnumBuilder.DefineLiteral('CreateThread', [uint32] 0x00000002)
[void]$EnumBuilder.DefineLiteral('VirtualMemoryOperation', [uint32] 0x00000008)
[void]$EnumBuilder.DefineLiteral('VirtualMemoryRead', [uint32] 0x00000010)
[void]$EnumBuilder.DefineLiteral('VirtualMemoryWrite', [uint32] 0x00000020)
[void]$EnumBuilder.DefineLiteral('DuplicateHandle', [uint32] 0x00000040)
[void]$EnumBuilder.DefineLiteral('CreateProcess', [uint32] 0x000000080)
[void]$EnumBuilder.DefineLiteral('SetQuota', [uint32] 0x00000100)
[void]$EnumBuilder.DefineLiteral('SetInformation', [uint32] 0x00000200)
[void]$EnumBuilder.DefineLiteral('QueryInformation', [uint32] 0x00000400)
[void]$EnumBuilder.DefineLiteral('QueryLimitedInformation', [uint32] 0x00001000)
[void]$EnumBuilder.DefineLiteral('Synchronize', [uint32] 0x00100000)
[void]$EnumBuilder.CreateType()
#endregion ProcessAccessFlags
#endregion Enums

#region Structs
#region TokPriv1Luid
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('TokPriv1Luid', $Attributes, [System.ValueType], 1, 0x10)
[void]$STRUCT_TypeBuilder.DefineField('Count', [int], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Luid', [long], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Attr', [int], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion TokPriv1Luid
#region LUID
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LUID', $Attributes, [System.ValueType], 8)
[void]$STRUCT_TypeBuilder.DefineField('LowPart', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('HighPart', [int], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LUID
#region LARGE_INTEGER
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LARGE_INTEGER', $Attributes, [System.ValueType], 8)
[void]$STRUCT_TypeBuilder.DefineField('LowPart', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('HighPart', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LARGE_INTEGER
#region LUID_AND_ATTRIBUTES
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LUID_AND_ATTRIBUTES', $Attributes, [System.ValueType], 12)
[void]$STRUCT_TypeBuilder.DefineField('Luid', [LUID], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Attributes', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LUID_AND_ATTRIBUTES
#region LSA_UNICODE_STRING
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LSA_UNICODE_STRING', $Attributes, [System.ValueType], 8, 0x0)
[void]$STRUCT_TypeBuilder.DefineField('Length', [uint16], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('MaximumLength', [uint16], 'Public')
$ctor = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructor(@([System.Runtime.InteropServices.UnmanagedType]))
$CustomAttribute = [System.Runtime.InteropServices.UnmanagedType]::LPWStr
$CustomAttributeBuilder = New-Object System.Reflection.Emit.CustomAttributeBuilder -ArgumentList $ctor, $CustomAttribute 
$BufferField = $STRUCT_TypeBuilder.DefineField('Buffer', [string], @('Public','HasFieldMarshal'))
$BufferField.SetCustomAttribute($CustomAttributeBuilder)
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LSA_UNICODE_STRING
#region LSA_OBJECT_ATTRIBUTES
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LSA_OBJECT_ATTRIBUTES', $Attributes, [System.ValueType], 8, 0x0)
[void]$STRUCT_TypeBuilder.DefineField('RootDirectory', [intptr], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('SecurityDescriptor', [intptr], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('SecurityQualityOfService', [intptr], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('ObjectName', [LSA_UNICODE_STRING], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Attributes', [int], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Length', [int], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LSA_OBJECT_ATTRIBUTES
#region LSA_ENUMERATION_INFORMATION
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('LSA_ENUMERATION_INFORMATION', $Attributes, [System.ValueType], 1, 0x8)
[void]$STRUCT_TypeBuilder.DefineField('Sid', [intptr], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion LSA_ENUMERATION_INFORMATION
#region TOKEN_STATISTICS
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('TOKEN_STATISTICS', $Attributes, [System.ValueType])
[void]$STRUCT_TypeBuilder.DefineField('TokenId', [LUID], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('AuthenticationId', [LUID], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('ExpirationTime', [LARGE_INTEGER], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('TokenType', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('ImpersonationLevel', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('DynamicCharged', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('DynamicAvailable', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('GroupCount', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('PrivilegeCount', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('ModifiedId', [LUID], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion TOKEN_STATISTICS
#region TOKEN_PRIVILEGES
$Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
$STRUCT_TypeBuilder = $ModuleBuilder.DefineType('TOKEN_PRIVILEGES', $Attributes, [System.ValueType])
[void]$STRUCT_TypeBuilder.DefineField('PrivilegeCount', [uint32], 'Public')
[void]$STRUCT_TypeBuilder.DefineField('Privileges', [LUID_AND_ATTRIBUTES], 'Public')
[void]$STRUCT_TypeBuilder.CreateType()
#endregion TOKEN_PRIVILEGES
#endregion Structs

#region Initialize Type Builder
$TypeBuilder = $ModuleBuilder.DefineType('PoShPrivilege', 'Public, Class')
#endregion Initialize Type Builder

#region Methods
#region AdjustTokenPrivileges
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'AdjustTokenPrivileges', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @([intptr], [bool], [TokPriv1Luid].MakeByRefType() ,[int], [intptr], [intptr]) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
)

$FieldValueArray = [Object[]] @(
    'AdjustTokenPrivileges', #CASE SENSITIVE!!
    $True,
    $True
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion AdjustTokenPrivileges
#region RevertToSelf
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'RevertToSelf', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @() #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
)

$FieldValueArray = [Object[]] @(
    'RevertToSelf', #CASE SENSITIVE!!
    $True,
    $True
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion RevertToSelf
#region OpenProcessToken Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'OpenProcessToken', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [intptr], 
        [int], 
        [intptr].MakeByRefType()
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
)

$FieldValueArray = [Object[]] @(
    'OpenProcessToken', #CASE SENSITIVE!!
    $True,
    $True
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion OpenProcessToken Method
#region GetCurrentProcess
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'GetCurrentProcess', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [intptr], #Method Return Type
    [Type[]] @() #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
)

$FieldValueArray = [Object[]] @(
    'GetCurrentProcess', #CASE SENSITIVE!!
    $True,
    $True
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('kernel32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion GetCurrentProcess Method
#region LookupPrivilegeValue Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LookupPrivilegeValue', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [string],              #lpSystemName
        [string],              #lpName
        [long].MakeByRefType() #lpLuid
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
)

$FieldValueArray = [Object[]] @(
    'LookupPrivilegeValue', #CASE SENSITIVE!!
    $True
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion LookupPrivilegeValue Method
#region LsaAddAccountRights Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaAddAccountRights', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [intptr],   #PolicyHandle
        [intptr],   #AccountSID
        [LSA_UNICODE_STRING[]], #UserRights
        [int]    #CountofRights
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
)

$FieldValueArray = [Object[]] @(
    'LsaAddAccountRights', #CASE SENSITIVE!!
    $True,
    $True,
    [System.Runtime.InteropServices.CharSet]::Auto
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray    
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaAddAccountRights Method
#region LsaRemoveAccountRights Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaRemoveAccountRights', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [intptr],               #PolicyHandle
        [intptr],               #AccountSID
        [bool],                 #AllRights
        [LSA_UNICODE_STRING[]], #UserRights
        [int]                   #CountofRights
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
)

$FieldValueArray = [Object[]] @(
    'LsaRemoveAccountRights', #CASE SENSITIVE!!
    $True,
    $True,
    [System.Runtime.InteropServices.CharSet]::Unicode
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray    
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaRemoveAccountRights Method
#region LsaOpenPolicy Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaOpenPolicy', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [LSA_UNICODE_STRING].MakeByRefType(), #SystemName
        [LSA_OBJECT_ATTRIBUTES].MakeByRefType(), #Object
        [uint32],
        [intptr].MakeByRefType()
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LsaOpenPolicy', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaOpenPolicy Method
#region LsaNTStatusToWinError Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaNtStatusToWinError', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint64], #Method Return Type
    [Type[]] @(
        [uint16]   #Status
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LsaNtStatusToWinError', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaNTStatusToWinError Method
#region LsaClose Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaClose', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint64], #Method Return Type
    [Type[]] @(
        [intptr]   #ObjectHandle
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LsaClose', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaClose Method
#region FreeSid Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'FreeSid', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [intptr], #Method Return Type
    [Type[]] @(
        [intptr]   #pSID
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'FreeSid', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion FreeSid Method
#region ConvertStringSIDToSID Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'ConvertStringSidToSid', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [string],                #StringSID
        [intptr].MakeByRefType() #ptrSID
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'ConvertStringSidToSid', #CASE SENSITIVE!!
    $True,
    $False,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion ConvertStringSIDToSID Method
#region LsaEnumerateAccountsWithUserRight Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaEnumerateAccountsWithUserRight', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [intptr], 
        [LSA_UNICODE_STRING[]], 
        [intptr].MakeByRefType(),
        [int].MakeByRefType()
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
)

$FieldValueArray = [Object[]] @(
    'LsaEnumerateAccountsWithUserRight', #CASE SENSITIVE!!
    $True,
    [System.Runtime.InteropServices.CharSet]::Unicode
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion LsaEnumerateAccountsWithUserRight Method
#region ConvertSidToStringSid Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'ConvertSidToStringSid', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [intptr],                #pSID
        [string].MakeByRefType() #sSID
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'ConvertSidToStringSid', #CASE SENSITIVE!!
    $True,
    $False,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion ConvertSidToStringSid Method
#region LsaFreeMemory Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaFreeMemory', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [intptr] #pBuffer
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LsaFreeMemory', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaFreeMemory Method
#region LsaClose Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LsaClose', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [uint32], #Method Return Type
    [Type[]] @(
        [intptr] #ObjetHandle
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LsaClose', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LsaClose Method
#region GetTokenInformation Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'GetTokenInformation', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [intptr],                  #TokenHandle
        [TOKEN_INFORMATION_CLASS], #TokenInformationClass
        [intptr],                  #TokenInformation
        [uint32],                  #TokenInformationLength
        [uint32].MakeByRefType()   #ReturnLength
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'GetTokenInformation', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion GetTokenInformation Method
#region LookupPrivilegeName Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LookupPrivilegeName', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [string],                    #lpSystemName
        [intptr],                    #lpLUID
        [System.Text.StringBuilder], #lpName
        [int].MakeByRefType()        #TokenInformationLength
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LookupPrivilegeName', #CASE SENSITIVE!!
    $True,
    $False,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LookupPrivilegeName Method
#region LookupPrivilegeNameW Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LookupPrivilegeNameW', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [intptr],
        [intptr],
        [intptr],
        [uint32].MakeByRefType()
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'LookupPrivilegeNameW', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LookupPrivilegeNameW Method
#region OpenProcess Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'OpenProcess', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [intptr], #Method Return Type
    [Type[]] @(
        [ProcessAccessFlags], #ProcessAccess
        [bool],               #InheritHandle
        [int]                 #processID
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'OpenProcess', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('kernel32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion OpenProcess Method
#region CloseHandle Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'CloseHandle', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [intptr] #Handle
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig')
)

$FieldValueArray = [Object[]] @(
    'CloseHandle', #CASE SENSITIVE!!
    $True,
    $True,
    $True
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('kernel32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion CloseHandle Method
#region LookupPrivilegeDisplayName Method
$PInvokeMethod = $TypeBuilder.DefineMethod(
    'LookupPrivilegeDisplayName', #Method Name
    [Reflection.MethodAttributes] 'PrivateScope, Public, Static, HideBySig, PinvokeImpl', #Method Attributes
    [bool], #Method Return Type
    [Type[]] @(
        [string],                    #SystemName
        [string],                    #PrivilegeName
        [System.Text.StringBuilder], #DisplayName
        [uint32].MakeByRefType(),    #cbDisplayName
        [uint32].MakeByRefType()     #LanguageID
    ) #Method Parameters
)

$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling')
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig'),
    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
)

$FieldValueArray = [Object[]] @(
    'LookupPrivilegeDisplayName', #CASE SENSITIVE!!
    $True,
    $False,
    $True,
    [System.Runtime.InteropServices.CharSet]::Unicode
)

$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
    $DllImportConstructor,
    @('advapi32.dll'),
    $FieldArray,
    $FieldValueArray
)

$PInvokeMethod.SetCustomAttribute($CustomAttribute)
#endregion LookupPrivilegeDisplayName Method
#endregion Methods

#region Create Type
[void]$TypeBuilder.CreateType()
#endregion Create Type

#region Load Public Functions
Try {
    Get-ChildItem "$ScriptPath\Scripts" -Filter *.ps1 | Select -Expand FullName | ForEach {
        $Function = Split-Path $_ -Leaf
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)
    Continue
}
#endregion Load Public Functions

#region Private Functions
Function AddSignedIntAsUnsigned {
    ##Source function from Matt Graeber and Joe Balek
    [cmdletbinding()]
	Param(
	[Parameter(Position = 0, Mandatory = $true)]
	[Int64]
	$Value1,
		
	[Parameter(Position = 1, Mandatory = $true)]
	[Int64]
	$Value2
	)
		
	[Byte[]]$Value1Bytes = [BitConverter]::GetBytes($Value1)
	[Byte[]]$Value2Bytes = [BitConverter]::GetBytes($Value2)
	[Byte[]]$FinalBytes = [BitConverter]::GetBytes([UInt64]0)

	if ($Value1Bytes.Count -eq $Value2Bytes.Count)
	{
		$CarryOver = 0
		for ($i = 0; $i -lt $Value1Bytes.Count; $i++)
		{
			#Add bytes
			[UInt16]$Sum = $Value1Bytes[$i] + $Value2Bytes[$i] + $CarryOver

			$FinalBytes[$i] = $Sum -band 0x00FF
				
			if (($Sum -band 0xFF00) -eq 0x100)
			{
				$CarryOver = 1
			}
			else
			{
				$CarryOver = 0
			}
            Write-Verbose "Carryover: $($CarryOver)"
		}
	}
	else
	{
		Throw "Cannot add bytearrays of different sizes"
	}
		
	return [BitConverter]::ToInt64($FinalBytes, 0)
}
Function GetPrivilegeDisplayName {
    Param ([Privileges]$Privilege)
    [uint32]$DisplayName = 150
    [uint32]$LanguageId = 0
    $StringBuilder = New-Object System.Text.StringBuilder
    [void]$StringBuilder.EnsureCapacity($DisplayName)
    $return=[PoshPrivilege]::LookupPrivilegeDisplayName(
        $env:COMPUTERNAME,
        $Privilege,
        $StringBuilder,
        [ref]$DisplayName,
        [ref]$LanguageId
    )
    If ($return) {
        $StringBuilder.ToString()
    }
}
#endregion Private Functions

#region Aliases
New-Alias -Name gppv -Value Get-Privilege
New-Alias -Name appv -Value Add-Privilege
New-Alias -Name rppv -Value Remove-Privilege
New-Alias -Name eppv -Value Enable-Privilege
New-Alias -Name dppv -Value Disable-Privilege
#endregion Aliases

#region Load Type and Format Files
Update-FormatData "$ScriptPath\TypeData\PoShPrivilege.Format.ps1xml"
#endregion Load Type and Format Files

Export-ModuleMember -Alias * -Function '*-Privilege'