
```powershell
<#Log in to your tenant #>
Connect-PnPOnline "https://yourtenant-admin.sharepoint.com" -Interactive

<# Get all custom themes that are available in the tenant #>
Get-PnPTenantTheme
<# Get a specific theme by name, and as JSON #>
Get-PnPTenantTheme "Elis main theme" -asJson

<# Create color palette variable #>
$color_palette = @{
      "themePrimary" = "#874070";
      "themeLighterAlt" = "#faf5f9";
      "themeLighter" = "#ecd8e5";
      "themeLight" = "#dbb8d0";
      "themeTertiary" = "#b77da5";
      "themeSecondary" = "#96507f";
      "themeDarkAlt" = "#7a3965";
      "themeDark" = "#673055";
      "themeDarker" = "#4c243f";
      "neutralLighterAlt" = "#faf9f8";
      "neutralLighter" = "#f3f2f1";
      "neutralLight" = "#edebe9";
      "neutralQuaternaryAlt" = "#e1dfdd";
      "neutralQuaternary" = "#d0d0d0";
      "neutralTertiaryAlt" = "#c8c6c4";
      "neutralTertiary" = "#a19f9d";
      "neutralSecondary" = "#605e5c";
      "neutralPrimaryAlt" = "#3b3a39";
      "neutralPrimary" = "#323130";
      "neutralDark" = "#201f1e";
      "black" = "#000000";
      "white" = "#ffffff";
}

<# Add theme to tenant #>
Add-PnPTenantTheme -Identity "Elis Main Theme" -Palette $color_palette -IsInverted $false

<# Set the theme on a site #>
Set-PnPWebTheme -Theme "Elis Main Theme" -WebUrl "https://yourtenant.sharepoint.com/sites/ThemeTestSite" 
```


> Note, to change the color of the suitebar/navigationbar (the top bar that follows you around MS365 not just in SharePoint Online) you can do so in the admin-center. Go to Admin –> Settings –> Org Settings –> Organization profile and select Custom Themes.