# "Set site as hub site"

## Author: Pelle Korsmo

## Tags: SharePoint, PowerShell, Create, Modify

A simple way to set a site as main hub.

```
ContentClass:Register-SPOHubSite

```

Example:

```
$adminUrl = "https://contoso-admin.sharepoint.com"
$hubsiteUr l= "https://contoso.sharepoint.com/sites/mainhub"
Connect-SPOService -Url $adminUrl 
Register-SPOHubSite $hubsiteUrl
```