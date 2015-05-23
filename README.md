# AzureMediaServicesClient


REST based client for Azure Media Services showing HTTP requests and responses to ingest, encode, dynamically package and play content back

This README shows a series of REST HTTP requests and responses performed against the Azure Media Services using the Google Chrome app Postman. It walks you through the breadth of basic Azure Media Services functionality - create an account, ingest content, encode it to your desired format using a pre-defined encoding profile, dynamically package and deliver it to a player.

Because this is not *code* per se - just a series of HTTP requests and responses, there is no code file checked into this repository. This README has everything you would need.

**DISCLAIMER**: Azure Media Services is changing very fast. These samples may not work if you are looking at them sometime in the future. I will try to keep these updated, but I can make no guarantees.

**DISCLAIMER**: This is meant for guidance and demonstration only. This is not intended to be used in production as-is.

## Common to all REST transactions below

Instead of repeating these *notes* for each REST transaction below, clustering them together here:

1. The "Postman-Token" header is added by Chrome's Postman extension. It is not required for any of the calls
2. Some of the HTTP headers are required, some are just good practice to have. Examples do not distinguish between them
3. For operations against Azure storage (like when we are uploading a media file), consider using the 'x-ms-client-request-id' header for request logging, examples here do not use it

## Set Yourself Up for making HTTP calls to AMS and receive something other than 4XX

### Step 0 [Create an Azure Media Services account](http://azure.microsoft.com/en-us/documentation/articles/media-services-create-account/) using the Azure Portal

### Step 1 Get an access token

###### Http Request

POST /v2/OAuth2-13 HTTP/1.1
Host: wamsprodglobal001acs.accesscontrol.windows.net
Content-Type: application/x-www-form-urlencoded
Content-Length: 120
Expect: 100-continue
Connection: Keep-Alive
Accept: application/json
Cache-Control: no-cache
Postman-Token: 25a3c853-d004-b0d4-2c52-a7e2fb4d3745

grant_type=client_credentials&client_id=testams&client_secret={{your_ams_key_here}}&scope=urn%3AWindowsAzureMediaServices

##### Http Response

{
"token_type": "http://schemas.xmlsoap.org/ws/2009/11/swt-token-profile-1.0",
"access_token": "http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1432165204&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=lWkRuaUeKz%2bTcDoD4zC9DGthFpSwhkiZrBQgGlgj4Vg%3d",
"expires_in": "21600",
"scope": "urn:WindowsAzureMediaServices"
}

##### Notes

1. Value of 'client_id' in request body is your Azure Media Services account name - retrieve it from the Azure Portal using the 'Manage Keys' button
2. Value of 'client_secret' in request body is your Azure Media Services key - retrieve it from the Azure Portal using the 'Manage Keys' button
3. Value of 'access_token' in response is time sensitive, see the 'expires_in' item in response, which is in seconds. You will need this access token in ALL calls to Azure Media Services below. As you navigate through these samples, if the token expires, you will have to repeat this step to generate a fresh access token to continue, and use the fresh token for subsequent calls
