# "My sites"

## Author: Reidar Husmo
## Tags: SharePoint, PowerShell, Search

A surprisingly common request is: which sites can I access?

The surprisingly simple answer is to search for 
```
ContentClass:STS_Site
```

As this is search, you can make it arbitrarily more complex; for example by asking for test sites:
```
ContentClass:STS_Site TEST
```
..remember that SharePoint search has "and" as the default operator.

```
ContentClass:STS_Site OR TEST
```
would also return documents and other.. stuff..

If you have access to _many_ sites, you may want to pipe the result into a file for later perusal, 
as shown in the accompanying PowerShell script: [Get-MySites.ps1](./Get-MySites.ps1)

Exercise: How can I get the sites that I have write or owner access to?