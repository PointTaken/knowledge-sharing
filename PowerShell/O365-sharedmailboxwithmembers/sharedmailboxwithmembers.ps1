Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName torstein.elvrum@bidbax.no



Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:Unlimited | Get-MailboxPermission |Select-Object Identity,User,AccessRights | Where-Object {($_.user -like '@')}|Export-Csv C:\Temp\sharedfolders.csv -NoTypeInformation

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:Unlimited | Get-MailboxPermission |Select-Object Identity,User,AccessRights | Where-Object {($_.user -like '*@*')}|Export-Csv C:\Temp\sharedfolders.csv  -NoTypeInformation 

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:Unlimited