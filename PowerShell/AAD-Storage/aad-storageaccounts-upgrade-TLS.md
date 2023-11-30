# Script content

This script appears to be a PowerShell script that upgrades the TLS (Transport Layer Security) version for Azure storage accounts.

The script prompts the user to confirm whether they want to proceed with the upgrade. If the user enters "Y" to continue, the script iterates over a collection of storage accounts and uses the Set-AzStorageAccount cmdlet to set the minimum TLS version to TLS 1.2 for each storage account.

If the user does not enter "Y" to continue, the script simply continues execution without performing any upgrades.

Overall, this script provides a way to automate the process of upgrading the TLS version for multiple Azure storage accounts.This script appears to be a PowerShell script that upgrades the TLS (Transport Layer Security) version for Azure storage accounts.


# The script

```Powershell
#install module az.resources, az.storage and az.accounts if not exists
         $modules = @("az.resources","az.accounts","az.storage")
         foreach ($module in $modules) {
         if (Get-Module -ListAvailable -Name $module) {
             Write-Host "Module $module is already installed" -ForegroundColor Green
            } else {
                Write-Host "Module $module is not installed, installing now" -ForegroundColor Yellow
                Install-Module $module -Force -AllowClobber
                Import-Module $module
                }
          }
#connect to azure
Connect-AzAccount
$subs = Get-AzSubscription | Out-GridView -Title "Select subscriptions to get storage accounts from" -PassThru
    foreach ($sub in $subs) {
        set-azcontext -subscription $sub.id
        $arr = @()
        #get all storage accounts with old tls
        $storageaccounts = Get-AzStorageAccount |Where-Object -Property MinimumTlsVersion -ne "TLS1_2" | Select-Object ResourceGroupName, StorageAccountName, Location, EnableHttpsTrafficOnly, MinimumTlsVersion
        write-host "Found the following storage accounts with old tls version" -ForegroundColor Yellow
        $storageaccounts | Select-Object -Property StorageAccountName| ft        
        $continue = read-host "Press Y to upgrade or N to skip"
        if ($continue -eq "Y") {
            foreach ($stg in $storageaccounts){
            Set-AzStorageAccount -Name $stg.StorageAccountName -ResourceGroupName $stg.resourcegroupname -MinimumTlsVersion TLS1_2
            }
        } else {
        continue }
    }

```


---
# Conclution
Microsoft will depricate all old versions of TLS in June 2024. Make sure you run this script before then!
