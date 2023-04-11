param(
    [string]$sub,
    [string]$app,
    [string]$rg
)

if (!$sub) {
    $activeSub = (az account show | ConvertFrom-Json)
    $subs = az account list | ConvertFrom-Json

    $counter = 0
    foreach($s in $subs){
        if($s.id -eq $activeSub.id){
            Write-Host "$($counter). $($s.name) - Active" -ForegroundColor Green
        }
        else{
            Write-Host "$($counter). $($s.name)"
        }
        $counter++
    }
    $subIndex = Read-Host -Prompt "Hit enter to use $($activeSub.name) or the index of another subscription"
    if($subIndex -ne ""){
        $selectedSub = $subs[[int]$subIndex]
        Write-Host "Selecting $($selectedSub.name) with id $($selectedSub.id)"
        az account set --subscription $selectedSub.id
    }
}
else{
    az account set --subscription $sub
}

if (!$app) {
    $app = Read-Host -Prompt "Enter the web app name"
}

$autoRg = $app -replace "fa", "rg"
if (!$rg) {
    $rg = Read-Host -Prompt "Enter the resource group or hit enter if you are happy and you know it with $autoRg"
    if($rg -eq ""){
        $rg = $autoRg
    }
}

$publishProfiles = az webapp deployment list-publishing-profiles --name $app --resource-group $rg | ConvertFrom-Json
$credential = "$($publishProfiles[0].userName):$($publishProfiles[0].userPWD)"
curl -u $credential https://$app.scm.azurewebsites.net/api/logstream