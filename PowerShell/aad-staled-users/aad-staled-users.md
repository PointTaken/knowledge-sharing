# Background

Have you ever thought “Do we have full controll over our offboarding routine?” then this script is perfect in your toolbox for checking for inactive users in Azure Active Directory.

I am stumbling across several Azure Active Directories where there are one or more user account enable and active without beeing in use by someone. That can be personal accounts not used anymore or it could be system accounts thats not in use.

In this post I`ll focus on a script where we get a output as a CSV file on when users last logged into their account.

---

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

![graph-api-permissions](/static/images/staled-azure-ad-users/staled-azure-ad-users-1.png)

---

# Script content

The script can be downloaded from my Github repostitory 
https://raw.githubusercontent.com/jurasmus/blogcontent/main/staledusers.ps1

The first part of the script is a set of variables that you need to change before running the script

```Powershell
$tenantID="YOUR TENANT ID"
$contentType = "application/json"
$exportpath = "'.\User_Signin_Activity.csv'"

$Body = @{    
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = "YOUR CLIENT ID"
    Client_Secret = "YOUR CLIENT SECRET"
}
```
Here we need to add your Tenant ID from your Azure Tenant and a Client ID (Application ID) and Client Secret from your app reg.
You can also set a Export path where the final result will be stored as a CSV.

The next part of the script is connecting to the Graph API authorizing as your App Registration witch has Audit log read and User read access and start getting users for the first page.

```Powershell
$ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $Body

$token = $ConnectGraph.access_token
$headers = @{ 'Authorization' = "Bearer $token" }


$queryURL = 'https://graph.microsoft.com/beta/users?$select=displayName,createddatetime,userprincipalname,mail,usertype,signInActivity,accountEnabled,companyName'
$SignInData = Invoke-RestMethod -Method GET -Uri $queryUrl -Headers $headers -contentType $contentType
$relLink = $SignInData.'@odata.nextLink'
```
Next the script will loop through users page for page and collect data within a variable called $outlist and when it`s done looping through all users it will export the result into a CSV file.

```Powershell
$outList = @()
while ($SignInData.'@odata.nextLink' -ne $null){
   foreach ($relLink in $SignInData.'@odata.nextLink') {
      Write-Output "Getting data from $relLink"
      $SignInData = Invoke-RestMethod -Method GET -Uri $relLink -Headers $headers -contentType $contentType

          foreach ($user in $SignInData.Value) {
            If ($Null -ne $User.SignInActivity)     {
               $LastSignIn = Get-Date($User.SignInActivity.LastSignInDateTime)
               $DaysSinceSignIn = (New-TimeSpan $LastSignIn).Days }
            Else { #No sign in data for user
               $LastSignIn = "Never or > 90 days" 
               $DaysSinceSignIn = "N/A" }

              $Values  = [PSCustomObject] @{
                  UPN                = $User.UserPrincipalName
                  DisplayName        = $User.DisplayName
                  Email              = $User.Mail
                  Created            = Get-Date($User.CreatedDateTime)
                  LastSignIn         = $LastSignIn
                  DaysSinceSignIn    = $DaysSinceSignIn
                  UserType           = $User.UserType
                  accountEnabled     = $user.accountEnabled
                  Company            = $user.companyName}
                $outList += $Values
          }
  }
}

$outList.Count
$outList | Export-Csv -Path $exportpath -Encoding UTF8 -NoTypeInformation
```

---
# Conclution
This script is perfect for your toolbox when you need to do manual checks of how your user state are. 
This can easily be transferred into a Azure Runbook for scheduled execution.
