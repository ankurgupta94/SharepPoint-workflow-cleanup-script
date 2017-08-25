Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue 
#Site collection URL 

$SiteUrl = "site name" 
$ListName = "list name" 
#Get Web and List objects 

$web = Get-SPWeb $SiteURL 
$list = $web.Lists[$ListName] 

#Reset the "Allow Deletion" Flag 

$list.AllowDeletion = $true 
$list.Update() 

$list.Delete() 

write-host "List has been deleted successfully!"  -ForegroundColor Green 



