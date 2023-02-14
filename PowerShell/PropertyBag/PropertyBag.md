A common SharePoint requirement is something along the lines of "Show me all the project sites that I have access to".
There are, as always, a plethora of ways to solve this.
One way is to specify the site type in an indexed property bag value.

Using PowerShell and PnP, this is simplicity itself.

```PowerShell
    Set-PnPPropertyBagValue -Key "PTSiteType" -Value "Project" -Indexed:$true`
```

Only... _of course_ it isn't that simple.

In order to run that line, you have to be a tenant administrator. Because of reasons.

And you need to be allowed to run scripts, so you need to set NoScriptSite to false.
```PowerShell
    Set-PnpSite -NoScriptSite:$false
    Set-PnPPropertyBagValue -Key "PTSiteType" -Value "Project" -Indexed:$true
    Set-PnpSite -NoScriptSite:$true # turn it back on!
```

And then we wait for search to pick it up, create a managed property/refinable string, and we're done.

But. How can I retrieve the property bag values by PowerShell?

```PowerShell
    Get-PnPPropertyBagValue etc
```
probably does the trick. Well. No. It is called `Get-PnPPropertyBag`. Because of _course_ it is.

Somebody that I used to know, forgot to set the indexed flag of some sites. And that flag is not returned by Get-PnPPropertyBag. Because that would be too easy. 
So how can we discover if a bag is indexed?

If we get _all_ the property bag values, we'll discover that there is a property bag entry called "vti_indexedpropertykeys".
Sounds promising. If we retrieve the value, we see that it is a pipeseparated messy string.
```
WBDoAGUAbQBlAFBAcgBpAG0AYQByAHkA|XeBDAG4AUABfAFAAcgBvAHYAaQBzAGkBbwBuAGkAbgBnAFQAZQBtAHAAbABhAHQAZQBJAGQA|
```
Hm. Doesn't that look like base64 unicode strings?

```PowerShell
    $raw = Get-PnPPropertyBag -Key "vti_indexedpropertykeys"
    $siteType = $raw.Split('|') | Where-Object { 
        $indexedKey = [System.Convert]::FromBase64String($_)
        $decoded = [System.Text.Encoding]::Unicode.GetString($indexedKey)
        $decoded -eq "PTSiteType"
    }
    if ($null -eq $siteType) {
        Write-Output "Not indexed."
    } else {
        Write-Output "Indexed."
    }
```
Though to be fair, that last bit is mostly esoteric.

To summarize: Create an indexed property bag. Create a refinable string which uses this. Use this in search/webparts/whatever.
