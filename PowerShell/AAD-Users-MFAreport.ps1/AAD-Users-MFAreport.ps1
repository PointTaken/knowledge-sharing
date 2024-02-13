<#
.SYNOPSIS
This script generates a report for Azure Active Directory (AAD) users' authentication methods, RBAC roles, and enterprise roles.

.DESCRIPTION
The script imports necessary modules, sets variables for connecting to Azure, retrieves users from Azure AD, and loops through each user to gather their authentication methods, RBAC roles, and enterprise roles. The collected data is then stored in a CSV file.

.PARAMETER TenantId
The Azure AD tenant ID.

.PARAMETER clientid
The clientid for the service principal used to connect to Azure.

.PARAMETER secret
The secret for the service principal used to connect to Azure.

.PREREQUISITES
- The script requires the "Microsoft.Graph.Identity.Governance" and "Microsoft.Graph.Identity.SignIns" modules to be installed.
- The service principal used to connect to Azure must have the 
"User.Read.All", "UserAuthenticationMethod.Read.All" and "EntitlementManagement.Read.All" permissions.

.OUTPUTS
CSV file containing the following information for each user:
- Sign-in name (UserPrincipalName)
- Authentication methods
- RBAC roles
- Enterprise roles

.NOTES
- This script requires the "Microsoft.Graph.Identity.Governance" and "Microsoft.Graph.Identity.SignIns" modules to be installed.
- The script also requires the "az.resources" module to be installed.
- Make sure to provide the correct values for the TenantId, clientid, and secret parameters.
#>

#importing modules
try{import-module "Microsoft.Graph.Identity.Governance" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.Governance" -force}
try{import-module "Microsoft.Graph.Identity.SignIns" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.SignIns" -force}
try{import-module "az.resources" -force -ErrorAction stop}
catch{install-module "az.resources" -force}
try{import-module "Microsoft.Graph.Users" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Users" -force}

#setting variables
$TenantId = "Enter your tenant ID here"
$clientid = 'Enter your clientid here'
$secret = 'Enter secret here' | ConvertTo-SecureString -AsPlainText -Force
$credential = [PSCredential]::New($clientid,$secret)
$credentialforaz = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientid, $secret

#connecting to azure
connect-azaccount -ServicePrincipal -TenantId $TenantId -Credential $credentialforaz
Connect-MgGraph -TenantId $TenantId -clientsecretcredential $credential

#getting users
$users = Get-MgUser -Filter 'accountEnabled eq true' -All
$arr = @()
foreach ($user in $users){
    $arr += $user.UserPrincipalName
}

#creating empty array
$naughtylist = @()
#setting variables for progress bar
$a = 100 / $arr.count
$i = 100 / $arr.count 

#looping through users
foreach ($dude in $arr){

    #progress bar
    $percent = [math]::round($i,2)
    Write-Progress -Activity "Writing report for authentication methods" -Status "$percent% Complete:" -PercentComplete $i
    $i = $i + $a
    #getting authentication methods
    $getauthmethod = Get-MgUserAuthenticationMethod -UserId $dude | Select-Object -ExpandProperty AdditionalProperties
    $authmeth = $getauthmethod | Convertto-Json
    $authmeth = $authmeth -replace '@odata.type','type'
    $authmeth = $authmeth -replace '#',''| ConvertFrom-Json
    #checking if user has MFA
    if ($authmeth.type -eq "microsoft.graph.phoneAuthenticationMethod"){
            #write-host "SMS auth used for $dude, naughty" -foregroundcolor red } else {write-host "MFA used, good work $dude" -foregroundcolor green
        }

    #empty variables
    $auth = $null
    $getrbacroles = $null
    $getentraroles = $null
    $stringofrbacroles = $null
    $stringofentraroles = $null 

    #getting rbac roles
    $getuser = Get-AzADUser -UserPrincipalName $dude
    try{$getrbacroles = Get-AzRoleAssignment -SignInName $getuser.UserPrincipalName}catch{}
    if($getrbacroles) {
        
        $getrbacroles | % -Process {
        $stringofrbacroles = $stringofrbacroles+$_.RoleDefinitionName+","
        }
        $stringofrbacroles = $stringofrbacroles.Substring(0, $stringofrbacroles.Length - 1)
    }
    #getting enterprise roles
    try{$getentraroles = Get-MgRoleManagementDirectoryRoleAssignment -Filter "PrincipalId eq '$($getuser.Id)'" -ErrorAction stop}catch{write-host "no enterpise roles"}
    if ($getentraroles) {
        $getentraroles | % -Process {
        $stringofentraroles = $stringofentraroles+(Get-MgRoleManagementDirectoryRoledefinition -UnifiedRoleDefinitionId $_.RoleDefinitionId).DisplayName+","
        }
        $stringofentraroles = $stringofentraroles.Substring(0, $stringofentraroles.Length - 1)
    }
    #getting authentication methods
    $authmeth.type | select -unique | % -Process {
        $auth = $auth+($_+",").Replace("microsoft.graph.","")
        }
    $auth = $auth.Substring(0, $auth.Length - 1)
    $auth = $auth -replace 'phoneAuthenticationMethod','Phone'
    $auth = $auth -replace 'passwordAuthenticationMethod','Password'
    $auth = $auth -replace 'windowsHelloForBusinessAuthenticationMethod','Hello for Business'
    $auth = $auth -replace 'microsoftAuthenticatorAuthenticationMethod','Authenticator'
    $auth = $auth -replace 'softwareOathAuthenticationMethod','OATH token'
    $auth = $auth -replace 'emailAuthenticationMethod','Email'
    $auth = $auth -replace 'fido2AuthenticationMethod','FIDO2'
    $weakauth = if($auth -like "*Password*" -or $auth -like "*Phone*" -and $auth -notlike "*Authenticator*" -and $auth -notlike "*OATH token*" -and $auth -notlike "*FIDO2*"){"Weak"}else{"Strong"}
    $priveliged = if($stringofrbacroles -or $stringofentraroles){"Priveliged user"}else{"User"}

    #creating object
    $roles = [PScustomObject]@{
        Signinname= $getuser.UserPrincipalName
        Authenticationmethods= $auth
        Authenticationstrength= $weakauth
        Rbacroles= $stringofrbacroles
        Entraroles= $stringofentraroles
        Priveliged= $priveliged
        }
    
    $naughtylist += $roles
    #$roles
}

#creating csv
New-Item -ItemType "directory" -Path "c:/temp" -Name "MFAreport" -Force
$naughtylist |convertto-csv -NoTypeInformation| out-file -FilePath "C:\temp\MFAreport\MFAreport.csv" -Encoding utf8 -Force