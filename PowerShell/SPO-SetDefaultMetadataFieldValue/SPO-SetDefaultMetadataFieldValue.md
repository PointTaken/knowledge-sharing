## Setting default value of a managed metadata field in a SharePoint list

The **C**lient had a perfectly reasonable request:
For sites of type AType, please change the default value of field AField from AValue to BValue.

So I created a tiny little script(*);

```PowerShell
$query = "complicated; not relevant to the rest of the script"
$sites = Invoke-PnPSearchQuery $query -All # Get the sites to change
foreach ($site in $sites.ResultRows) {
    $url = $site.SPWebUrl
    Write-Host $url -ForegroundColor Yellow
    Connect-PnPOnline -Url $url -Interactive
    $field = Get-PnpField -Identity "AField"
    if ($null -ne $field) {
        if ($field.DefaultValue.IndexOf("AValue") -gt -1) {
            $field.DefaultValue = "-1;#BValue|feedbeef-0365-acea-ba5e-0ff1ce001337" # 'possibly' not the real ID
            $field.UpdateAndPushChanges($true)
            Write-Host "`tFixed field at site level, pushed to library" -ForegroundColor Cyan
        }
    }
    Invoke-PnPQuery
}
```

1) Do a test run.
2) Does it look ok at site level? (yes)
3) Does it look ok in the document library? (yes)
4) Create a new document. Does it get BValue? (yes)
5) Run it for all sites and tell **C**lient.
6) **C**lient happy?
7) Not noticeably, no.

If you (i.e. the client) _upload_ a document, the value does _not_ get set.

The fix turned out to be simple; library settings, click the AField field, then OK. Without changing anything.
Yeah. Ok if you have three sites, not ok if you have three thousand.

I'll skip all the 'solutions' that turned out not to be a solution.

The real solution turned out to be to ask ChatGPT.
The proposed solution wasn't quite on the money, but it mentioned a PnP command I didn't know.

```PowerShell
    Set-PnPDefaultColumnValues -List Documents -Field AField -Value "-1;#BValue|feedbeef-0365-acea-ba5e-133713371337"
```

And _now_ the **C**lient was happy.

(*) - the real script is obviously more complicated, if for no other reason that I like to log 
what was done. Also: error handling.