#importing modules
try{import-module "Microsoft.Graph.Identity.Governance" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.Governance" -force}
try{import-module "Microsoft.Graph.Identity.SignIns" -force -ErrorAction stop}
catch{install-module "Microsoft.Graph.Identity.SignIns" -force}
try{import-module "az.resources" -force -ErrorAction stop}
catch{install-module "az.resources" -force}

#setting variables
$TenantId = "af650eaa-f166-4048-8a86-c1bed50150a1"
$username = 'd8e333a2-1e45-4767-b801-7903cfa29398'
$password = 'yuW8Q~uJQgIHVxMYXUoIn3OZihYANkEoGlC8hbx7' | ConvertTo-SecureString -AsPlainText -Force
$credential = [PSCredential]::New($username,$password)
$Credential2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password

#connecting to azure
connect-azaccount -ServicePrincipal -TenantId $TenantId -Credential $credential2
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
New-Item -ItemType "directory" -Path "c:/temp" -Name "griegseafood"
$naughtylist |convertto-csv -NoTypeInformation| out-file -FilePath "C:\temp\griegseafood\adminuserslowMFA2.csv" -Encoding utf8 -Force