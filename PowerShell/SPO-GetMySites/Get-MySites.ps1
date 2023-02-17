# Connect-pnponline -Interactive -Url "https://_tenant_.sharepoint.com/"

$rawResults = Invoke-PnPSearchQuery -query "ContentClass:STS_Site" -All
# Yes, technically there are safer and better ways of creating csvs. But that is not the point of this example. Keep it simple.
$rawResults.ResultRows | ForEach-Object { 
    """$($_.Title)"",$($_.SPWebUrl)" | out-file "C:\_foldername_\sites.csv" -Append:$true 
}