<#

.Synopsis
    This script will get all classic administrators in all subscriptions and export the report to a CSV file. It will also remove the classic administrators and reassign them with the Contributor role if the user selects the option.
    YOU NEED:
    User or Service Principal with Owner or User Access Administrator role in the subscription
    Az module installed


.PARAMETER      
    [string]$userlogin = $false,
    [string]$TenantId,
    [string]$ApplicationId,
    [string]$ApplicationPassword

.EXAMPLE 
    SERVICE PRINCIPAL
    .\AAD-Get_Classic_admins.ps1 -userlogin $false -TenantId "XXXXXXXX-xxxx-xxxx-xxxx-XXXXXXX" -ApplicationPassword "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -ApplicationId "XXXXXXXX-xxxx-xxxx-xxxx-XXXXXXX"
.EXAMPLE
    USER LOGIN
    .\AAD-Get_Classic_admins.ps1 -userlogin $true

.NOTES
    File Name  : Get-ClassicAdmins.ps1
    Author     : Odd Daniel Taasaasen
    Date       : 2024-03-18
    Version    : 1.0
    Change History:
        1.0 - Odd Daniel Taasaasen - Initial Script
#>
[CmdletBinding()]
param(
[string]$userlogin = $false,
[string]$TenantId,
[string]$ApplicationId,
[string]$ApplicationPassword
)
# Import the Az module
Import-Module Az.accounts

# Connect to Azure
if($userlogin -eq $true) {
    Connect-AzAccount
} else {
    $SecuredPassword=ConvertTo-SecureString $ApplicationPassword -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecuredPassword
    Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential -WarningAction:SilentlyContinue | Out-Null
}


$subs = get-azsubscription
$path = "C:\temp\classic-admins.csv"
$roles = @()

# Select report only or report and reassign
$selectedOption = Read-Host "1. Report only `n2. Remove and reassign to contributor`nChoose 1 or 2"
if($selectedOption -eq "2") {
    write-host "You have selected to remove and reassign the classic administrators" -ForegroundColor Yellow
    $selectedroles = Read-Host "Which role would you like to reassign the classic administrators to? `n1. Owner`n2. Contributor`n3. Reader `nChoose 1, 2 or 3"
} else {
    write-host "You have selected to only report the classic administrators" -ForegroundColor Yellow
}

# Get the token
$token = (Get-AzAccessToken -ResourceUrl https://management.azure.com).Token

# Loop through each subscription
foreach ($sub in $subs) {
    write-host "-------------------------------------------------------------------------------"
    write-host "Currently checking subscription: $($sub.Name)"


    # Get all classic administrators with API
    $uri = "https://management.azure.com/subscriptions/$($sub.id)/providers/Microsoft.Authorization/classicadministrators?api-version=2015-06-01"

    # Get all classic administrators
    try{
        $classicAdministrators = Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $token"} -Method Get -erroraction stop
    } catch {
        write-host "No classic administrators in $($sub.Name)" -ForegroundColor Yellow
        continue
    }
    $classicAdministrators = $classicAdministrators.value
    write-host "Found $($classicAdministrators.Count) classic administrators in $($sub.Name)" -ForegroundColor Red
    # Display the classic administrators
    foreach ($admin in $classicAdministrators) {
    
        if($selectedOption -eq "2") {
            # Remove the classic administrator
            try{
                $uri = "https://management.azure.com/subscriptions/$($sub.Id)/providers/Microsoft.Authorization/classicAdministrators/$($admin.Name)?api-version=2015-06-01&adminType=serviceAdmin"
                Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $token"} -Method Delete -erroraction stop
                write-host "Removed $($admin.Properties.emailaddress) from $($sub.Name)" -ForegroundColor Green
                $removed = $true
            } catch {
                try{
                    $uri = "https://management.azure.com/subscriptions/$($sub.Id)/providers/Microsoft.Authorization/classicAdministrators/$($admin.Name)?api-version=2015-06-01"
                    Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $token"} -Method Delete -erroraction stop
                    write-host "Removed $($admin.Properties.emailaddress) from $($sub.Name)" -ForegroundColor Green
                    $removed = $true
                } catch {
                write-host "Could not remove $($admin.Properties.emailaddress) from $($sub.Name)" -ForegroundColor Red
                write-error $_.Exception.Message
                $removed = $false
                }
            }
            # Reassign with selected rbac role
            if($selectedroles -eq "1") {
                $selectedrbacrole = "Owner"
            } elseif ($selectedroles -eq "2") {
                $selectedrbacrole = "Contributor"
            } else {
                $selectedrbacrole = "Reader"
            }
            try{
            New-AzRoleAssignment -SignInName $admin.Properties.emailaddress -RoleDefinitionName $selectedrbacrole -ErrorAction Stop | Out-Null
            write-host "Reassigned $($admin.Properties.emailaddress) to $($sub.Name) with the $($selectedrbacrole) role" -ForegroundColor Green
            } catch {
                write-host "Could not reassign $($admin.Properties.emailaddress) to $($sub.Name) with the $($selectedrbacrole) role" -ForegroundColor Red 
            }
        } else {
            $removed = $false
        }
        # Get the current RBAC roles for the current user
        $rbac = Get-AzRoleAssignment -SignInName $admin.Properties.emailaddress -Scope "/subscriptions/$sub" -ErrorAction SilentlyContinue
        if($rbac -eq $null) {
            $rbac = [PSCustomObject]@{
                RoleDefinitionName = "No role"
            }
        } elseif ($rbac.count -gt 1) {
            $rbacstring = $rbac.RoleDefinitionName -join ", "
            $rbac = [PSCustomObject]@{
                RoleDefinitionName = $rbacstring
            }
        } else {
            $rbac = $rbac
        }

        $roleobject = [PSCustomObject]@{
            Subscription = $sub.Name
            Role = $admin.Properties.role
            Email = $admin.Properties.emailaddress
            Removed = $removed
            RBAC = $rbac.RoleDefinitionName
        }
        $roles += $roleobject
    }
    
}
write-host "-------------------------------------------------------------------------------"
# Export the report
$roles | Export-Csv -Path $path -NoTypeInformation -force
write-host "Report exported to $path" -ForegroundColor Green

