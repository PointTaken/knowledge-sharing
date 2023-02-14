<#
set a property bag value.
#>
function Set-PropertyBagValue {
    param (
        [string]$key, [string]$value, [boolean]$indexed
    )
    $currentValue = Get-PnPPropertyBag -Key $key
    if ($currentValue -ne $value) {
        Set-PnpSite -NoScriptSite:$false
        Set-PnPPropertyBagValue -Key $key -Value $value -Indexed:$indexed
        Set-PnpSite -NoScriptSite:$true
    }
}

function Confirm-PropertyBagKeyIsIndexed([string]$key) {
    $response = $false
    $raw = Get-PnPPropertyBag -Key "vti_indexedpropertykeys"
    $indexed = $raw.Split('|') | Where-Object { 
        $indexedKey = [System.Convert]::FromBase64String($_)
        $decoded = [System.Text.Encoding]::Unicode.GetString($indexedKey)
        $decoded -eq $key
    }
    if ($null -ne $indexed) {
        $response = $true
    }
    $response
}
