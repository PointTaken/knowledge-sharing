# Synopsis
Created by Odd Daniel Taasaasen

# Script content

This script generates a report for Azure Active Directory (AAD) users' authentication methods, RBAC roles, and enterprise roles.
The script imports necessary modules, sets variables for connecting to Azure, retrieves users from Azure AD, and loops through each user to gather their authentication methods, RBAC roles, and enterprise roles. The collected data is then stored in a CSV file.

# Parameters
The Azure AD tenant ID.
The clientid for the service principal used to connect to Azure.
The secret for the service principal used to connect to Azure.

# Prerequsites
An app registration with the role directory.read.all

Powershell 7 

Modules: 
Microsoft.Graph.Identity.Governance
Microsoft.Graph.Identity.Identity
az.resources

# COOL EXCEL SHEET!

Please download the MFAreport.xlsx file and place it in C:/Temp/MFAreport/
It might hopefully connect to the .csv file you have created. 
If not, it is just to go to datasources in excel and reselect the file.

# The script, enjoy!

```Powershell
#importing modules
try{import-module "Microsoft.Graph.Identity.Governance" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.Governance" -force}
try{import-module "Microsoft.Graph.Identity.SignIns" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.SignIns" -force}
try{import-module "az.resources" -force -ErrorAction stop}
catch{install-module "az.resources" -force}

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
$users = Get-AzADUser
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
        $auth = ($_+",").Replace("microsoft.graph.","")
        }
    $auth = $auth.Substring(0, $auth.Length - 1)

    #creating object
    $roles = [PScustomObject]@{
        signinname= $getuser.UserPrincipalName
        authenticationmethods= $auth
        rbacrole= $stringofrbacroles
        entrarole= $stringofentraroles
    }
    $naughtylist += $roles
    #$roles
}
#creating csv
New-Item -ItemType "directory" -Path "c:/temp" -Name "MFAreport" -Force
$naughtylist |convertto-csv -NoTypeInformation| out-file -FilePath "C:\temp\MFAreport\MFAreport.csv" -Encoding utf8 -Force

```