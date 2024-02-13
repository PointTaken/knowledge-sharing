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
# Pre-requisite
Create a App Registration within your Azure AD! You can use this guide official Microsoft Learn guide
https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application

Remember to take note from:
* Tenant ID
* Application ID
* Application Secret

And your newly created App Reg need a API permission
* AuditLog.Read.All
* User.Read.All

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
$outList = @()

do {
    $SignInData = Invoke-RestMethod -Method GET -Uri $queryURL -Headers $headers -ContentType $contentType

    foreach ($user in $SignInData.value) {
        Write-Host "Successfully got sign-in data for user $($user.UserPrincipalName)" -ForegroundColor Green
        $LastSignIn = "Never or > 90 days"
        $DaysSinceSignIn = "N/A"

        if ($user.SignInActivity -ne $null) {
            try {
                $LastSignIn = Get-Date($user.SignInActivity.LastSignInDateTime)
                $DaysSinceSignIn = (New-TimeSpan $LastSignIn).Days 
            }
            catch {
                # Handle exception if necessary
            }
        }

        # Get license info
        $skuname = "No license"
        if ($user.LicenseAssignmentStates.SkuId -ne $null) {
            $skuid = $user.LicenseAssignmentStates.SkuId -split " "
            $skuname = GetSkuName -SkuId $skuid -dictionary $dictionary
        }

        $Values = [PSCustomObject] @{
            UPN                = $user.UserPrincipalName
            DisplayName        = $user.DisplayName
            Email              = $user.Mail
            Created            = Get-Date($user.CreatedDateTime)
            LastSignIn         = $LastSignIn
            DaysSinceSignIn    = $DaysSinceSignIn
            UserType           = $user.UserType
            accountEnabled     = $user.accountEnabled
            Company            = $user.companyName
            Licenses           = $skuname
        }

        $outList += $Values
    }

    $nextLink = $SignInData.'@odata.nextLink'
    if ($nextLink -ne $null) {
        $queryURL = $nextLink
    }
    else {
        # Break out of the loop if there's no nextLink
        break
    }
} while ($true)

# Process the collected data
# For example, output to a CSV file
 write-host $outList.Count "users found" -ForegroundColor Yellow
 $outList | ConvertTo-Csv | Out-File -FilePath $exportpath -Encoding UTF8 