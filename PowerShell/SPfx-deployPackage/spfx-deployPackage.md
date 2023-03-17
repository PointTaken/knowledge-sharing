## **Deploy SPfx package to app catalog**
> Note, this uses PNP-powershell

```powershell
Connect-PnPOnline "yourtenantURL" -Interactive

$appcatalogURL = Get-PnPTenantAppCatalogUrl

$appCatConnection = Connect-PnPOnline $appcatalogURL -ReturnConnection -Interactive

Add-PnPApp -Path "./project-wp.sppkg" -Connection $appCatConnection -Publish
```
If you allready know the appcatalog url you can connect to it directly
```powershell
Connect-PnPOnline "appcatalogurl" -Interactive

Add-PnPApp -Path "./project-wp.sppkg"  -Publish 

```

### **Making the app available tenant wide**
Use -SkipFeatureDeployment to centrally deployed the solution across the tenant.
```powershell
Add-PnPApp -Path "./project-wp.sppkg" -Connection $appCatConnection -Publish -SkipFeatureDeployment
```

### **Update exisiting app**
Use -Overwrite to update an existing solution.
```powershell
Add-PnPApp -Path "./project-wp.sppkg" -Publish -Overwrite
```