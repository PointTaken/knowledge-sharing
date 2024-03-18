# Background

On 31 August 2024, Azure classic administrator roles will be retired. If your organization has active Co-Administrator or Service Admin roles, you’ll need to transition to using Azure role-based access control (RBAC) roles by then. All Azure classic resources and Azure Service Manager will also be retired on that date. 

You may continue using these Azure classic admin roles until they’re retired. However, starting 3 April 2024, you’ll no longer be able to add new Co-Administrator roles through the Azure portal.   

---

# Pre-requisite
You can choose between Service Principal or User to perform this script. 
Required permissions for the Subscriptions:
* Owner
* User Access Admin

If you use Service Principal, remember to take note from:
* Tenant ID
* Application ID
* Application Secret

# Important notice
You can select from the following modes: Report or Remove and reassign.
Report:
Will only create a .csv file in your c:/Temp/classic-admins.csv

Remove and reassign:
Will remove the Classic administrators it will find.
Then reassign with a new RBAC role. 
You will be prompted which RBAC role you want to assign: Owner, Reader or User Access Admin.

# How to start?
Just run the script from your Powershell terminal. 
5.1 and 7.2 supported.

## EXAMPLE SERVICE PRINCIPAL
    
    .\AAD-Get_Classic_admins.ps1 -userlogin $false -TenantId "16518b96-58d8-41fc-8410-8bc114322a52" -ApplicationPassword "SECRET HERE" -ApplicationId "XXXXXX-xxxx-xxxx-xxxx-XXXXXXXXX"

## EXAMPLE USER LOGIN
    .\AAD-Get_Classic_admins.ps1 -userlogin $true

