param (
    [string]$projectName,
    [string]$env,
    [string]$location,
    [string]$customerName
)

az --version
$rg = az group create --name "rg-$customerName-$projectName-$($env.substring(0,1))" --location westeurope

$deployment = az deployment group create `
    --resource-group ($rg | ConvertFrom-Json).Name `
    --template-file ./main.bicep `
    --parameters env=$env projectName=$projectName customerName=$customerName #`
    # --parameters "./main.secretParameters.$env.json" `

# Debug output from module
$deployment | Format-List
$deploymentObject = $deployment | ConvertFrom-Json
$outputs = $deploymentObject.properties.outputs
$storageAccountName = $outputs.storageAccountName.value

Write-Host ($outputs | Format-Table | Out-String)
Write-Host "storageAccountName=$storageAccountName)"

# Outputs to be used in other jobs
Write-Host "##vso[task.setvariable variable=storageAccountName;isOutput=true]$($outputs.storageAccountName.value)"