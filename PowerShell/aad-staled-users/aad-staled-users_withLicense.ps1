<#
.Synopsis

A script will export all users from tenant to csv file with sign in activity and license info
It uses a dictionary file to get the license name from the license GUID. Updated October 2023

.DESCRIPTION

Required modules: 
Microsoft.PowerShell.Utility

Required files: 
MS_SKU.csv

Required permissions:
    Application permissions:
    User.Read.All
    AuditLog.Read.All

.EXAMPLE


.Notes

Created   : 2023-30-11
Version   : 1.0
Author    : Odd Daniel Taasaasen
Twitter   : @Odd_Taasaasen
Blog      : https://wwww.pointtaken.no
#>



function GetSkuName {
    param (
       [Parameter(Mandatory=$true,Position=0)]
       [array]$SkuId,
       #dictionary
       [object]$dictionary
    )
    $SkuName = $null
    foreach ($id in $skuid) {
       $SkuN = $dictionary | Where-Object {$_.GUID -like "*$id*"} | Select-Object -ExpandProperty Product_Display_Name | select -First 1
       if ($skuname -eq $null) {
          $SkuName = $SkuN
       } else {
       $SkuName = $SkuName + "," + $SkuN
       }
    }
    return $SkuName
 }
 
 $dictionary = get-content -Path ".\MS_SKU.csv" | ConvertFrom-Csv -Delimiter ","
 $tenantID="YOUR TENANT ID"
 $contentType = "application/json"
 $exportpath = "C:\TEMP\User_Signin_Activity.csv"
 
 $Body = @{    
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = "YOUR CLIENT ID"
    Client_Secret = "YOUR CLIENT SECRET"
 }
 $ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $Body
 
 $token = $ConnectGraph.access_token
 $securedtoken = ConvertTo-SecureString $token -AsPlainText -Force
 $headers = @{ 'Authorization' = "Bearer $token" }
 
 
 $queryURL = 'https://graph.microsoft.com/beta/users?$select=displayName,createddatetime,userprincipalname,mail,usertype,signInActivity,accountEnabled,companyName,LicenseAssignmentStates'
 $SignInData = Invoke-RestMethod -Method GET -Uri $queryUrl -Headers $headers -contentType $contentType
 $relLink = $SignInData.'@odata.nextLink'
 
 $outList = @()
 while ($SignInData.'@odata.nextLink' -ne $null){
    foreach ($relLink in $SignInData.'@odata.nextLink') {
       $SignInData = Invoke-RestMethod -Method GET -Uri $relLink -Headers $headers -contentType $contentType
           foreach ($user in $SignInData.Value) {
             write-host "successfully got sign in data for user" $User.UserPrincipalName -ForegroundColor Green
             If ($Null -ne $User.SignInActivity)     {
                try {
                   $LastSignIn = Get-Date($User.SignInActivity.LastSignInDateTime)
                   $DaysSinceSignIn = (New-TimeSpan $LastSignIn).Days 
                   
                }
                catch {
                }
             }
             Else { #No sign in data for user
                $LastSignIn = "Never or > 90 days" 
                $DaysSinceSignIn = "N/A" }
             #get license info
                $skuid = $null
                $skuname = $null
                try {
                   $skuid = ($user.LicenseAssignmentStates.SkuId).split(" ")
                }
                catch {}
                if ($skuid -eq $null) {
                   $skuname = "No license"
                } else{
                $skuname = GetSkuName -SkuId $skuid -dictionary $dictionary
                }
               $Values  = [PSCustomObject] @{
                   UPN                = $User.UserPrincipalName
                   DisplayName        = $User.DisplayName
                   Email              = $User.Mail
                   Created            = Get-Date($User.CreatedDateTime)
                   LastSignIn         = $LastSignIn
                   DaysSinceSignIn    = $DaysSinceSignIn
                   UserType           = $User.UserType
                   accountEnabled     = $user.accountEnabled
                   Company            = $user.companyName
                   Licenses           = $skuname}
                 $outList += $Values
                }
       }
   }
 
 
 write-host $outList.Count "users found" -ForegroundColor Yellow
 $outList | ConvertTo-Csv | Out-File -FilePath $exportpath -Encoding UTF8 