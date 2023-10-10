## Usage

# Update the variables

$SiteURL = "https://"COMPANYSITE".sharepoint.com/"
example: "https://pointtakenas.sharepoint.com/"

$ReportOutput = "C:\Github\AdminOwnerPermissions-new.csv"

# Run
Run the script and authenticate twice - then wait :)


# The script
``` PowerShell
#Set Variables
$SiteURL = "https://"COMPANYSITE".sharepoint.com/"
$ReportOutput = "C:\Github\AdminOwnerPermissions-new.csv"

#Connect to PnP Online
#$Cred = Get-Credential
Connect-PnPOnline -Url $SiteURL -Interactive


#Get All Site collections
$SitesCollection = Get-PnPTenantSite

$Global:Results = @()

Function Add-Report($GroupOwners){
    $Global:Results += New-Object PSObject -Property ([ordered]@{
        SiteName               = $Site.Title
        SiteURL                = $Site.url
        Owners                 = $GroupOwners
    })
}

#Loop through each site collection
ForEach($Site in $SitesCollection)
{
    #Write-host -F Green "Site Owner(s) of the site: " $Site.Url
    Connect-PnPOnline -Url $Site.Url -Interactive
    If ($Site.Template -like 'GROUP*')
    {

        #Get Group Owners
        $GroupOwners= (Get-PnPMicrosoft365GroupOwners -Identity ($Site.GroupId)  | Select -ExpandProperty Email) -join "; "
    }
    Else
    {
        #Get Site Owner
        $GroupOwners = $Site.Owner
    }
    Add-Report -GroupOwners $GroupOwners
    #powershell script to get sharepoint online site owners
    #Write-host $GroupOwners
}

#Close status notification
Write-Progress -Activity "Processing $($ItemProcess)%" -Status "Site '$($Site.URL)"

If($Global:Results.count -eq 0){
    Write-host -b Green "Report is empty!"
}
Else{
    #Export the results to CSV
    If (Test-Path $ReportOutput) { Remove-Item $ReportOutput }
    $Global:Results | Export-Csv -Path $ReportOutput -Encoding UTF8 -NoTypeInformation
    Write-host -b Green "Report Generated Successfully!"
    Write-host -f Green $ReportOutput
}
```