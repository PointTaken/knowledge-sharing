$TenantName = "ptaken.no"
$TenantId = "16518b96-58d8-41fc-8410-8bc114322a52"

$ApplicationId = "e98602c4-ead0-49d8-82a0-xxxxxxxxxx" # app registration clientId
$clientSecret = "sKNf3F@eeeeeee7u-xxxxxx"
$SecuredPassword=ConvertTo-SecureString $clientSecret -AsPlainText -Force

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecuredPassword
Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential

Get-Azcontext

$Scope = "https://graph.microsoft.com/.default"