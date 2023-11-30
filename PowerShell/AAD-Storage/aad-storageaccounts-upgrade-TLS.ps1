#Made by Odd Daniel Taasaasen @ Point Taken AS

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


    