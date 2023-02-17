<#
This script finds all labels and deletes them.
Does a test first, to ensure that you have included all labels you want to keep.

REMEMBER TO INSERT YOUR EXCEPTIONS IN LINE 10

Made by Odd Daniel Taasaasen
#>

Connect-IPPSSession
$all = get-label 
$nodelete = @('label1','label2','label3')


#test if what you want is deleted is OK

foreach ($label in $all) {
if ($nodelete.Contains($label.name)) {
write-host "KEEP: "$label.Name
}
else {
write-host "DELETE: "$label.Name}
}

$user = read-host "do you want to continue? type 'Y' | if you want to exit type 'N' and press enter"

if ($user -eq "N") {
break
}
#perform the deletion

foreach ($label in $all) {
if ($nodelete.Contains($label.name)) {
write-host "KEEP: " $label.Name
}
else {
remove-label -Identity $label.Name -Confirm:$false
write-host "DELETE: " $label.Name}
}