# Script from https://blogs.msdn.microsoft.com/tehnoonr/2017/10/20/creating-communication-sites-in-sharepoint-online-programatically/
# Credit to Tehnoon Raza
#
# Edited By Brian Wilson
#
# Note if your account is using 2FA you will need to use your App Password for this to run...
#
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
################################## Config Section Start ############################################
#The Url of the root SharePoint site for your tenant. Ensure there is no trailing slash at the end!
$rootUri = "https://charlesriverlabs.sharepoint.com"
#The REST endpoint to create the communication site
$restEndPoint = $rootUri + "/_api/sitepages/communicationsite/create"
#Let's set the classification that we want to assign to the site.
$siteClass = "Charles River Labs Confidential"
#There are 3 possible designs for communication sites. Use "null" for "Topic", "6142d2a0-63a5-4ba0-aede-d9fefca2c767" for Showcase and "f6cc5403-0d63-442e-96c0-285923709ffc" for a blank site
$designId = "6142d2a0-63a5-4ba0-aede-d9fefca2c767"
$siteTitle = "Brians Comms Site"
$siteDesc = "This is my communications site"
$siteUrl = "https://charlesriverlabs.sharepoint.com/sites/briantest2"
$siteLCID = "1033"
############################### Config Section End ################################################
#Get the credentials from the user
if ($creds -eq $null)
{
$creds = Get-Credential
}
#Get the user context
$context = New-Object Microsoft.SharePoint.Client.ClientContext($rootUri)
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($creds.UserName, $creds.Password)
$context.ExecuteQuery()
#Get the Auth cookie
$authCookie = $context.Credentials.GetAuthenticationCookie($rootUri, $true)
#Get the Form Digest
$digest = $context.GetFormDigestDirect()
#Now let's build the REST web request
$contentType = 'application/json;odata=verbose'
$headers = @{}
$headers["Accept"] = "application/json;odata=verbose"
$headers["X-RequestDigest"] = $digest.DigestValue
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.SetCookies($rootUri, $authCookie)
$body = @{
request = @{
__metadata = @{type ="SP.Publishing.CommunicationSiteCreationRequest"}
AllowFileSharingForGuestUsers = 'false'
Classification = $siteClass
Description = $siteDesc
SiteDesignId = $designId
Title = $siteTitle
Url = $siteUrl
lcid = $siteLCID
}
}
$jsonBody = ConvertTo-Json $body
$result = $null
#Shoot the request to the cloud!
$result = Invoke-RestMethod -Method Post -ContentType $contentType -Headers $headers -Uri $restEndPoint -Body $jsonBody -WebSession $session
if ($result -ne $null -and $result.d.Create.SiteStatus -eq 2)
{
Write-Output "Site created successfully at "$result.d.Create.SiteUrl
}
else
{
Write-Host "Failed to create site! Grab a fiddler trace while reproducing the failure to learn more about the failure!"
}