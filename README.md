# AzureMediaServicesClient


REST based client for Azure Media Services showing HTTP requests and responses to ingest, encode, dynamically package and play content back

This README shows a series of REST HTTP requests and responses performed against the Azure Media Services using the Google Chrome app Postman. It walks you through the breadth of basic Azure Media Services functionality - create an account, ingest content, encode it to your desired format using a pre-defined encoding profile, dynamically package and deliver it to a player.

Because this is not *code* per se - just a series of HTTP requests and responses, there is no code file checked into this repository. This README has everything you would need.

**DISCLAIMER**: Azure Media Services is changing very fast. These samples may not work if you are looking at them sometime in the future. I will try to keep these updated, but I can make no guarantees.

**DISCLAIMER**: This is meant for guidance and demonstration only. This is not intended to be used in production as-is.

## Common to all REST transactions below:

Instead of repeating these *notes* for each REST transaction below, clustering them together here:

1. The "Postman-Token" header is added by Chrome's Postman extension. It is not required for any of the calls
2. Some of the HTTP headers are required, some are just good practice to have. Examples do not distinguish between them
3. For operations against Azure storage (like when we are uploading a media file), consider using the 'x-ms-client-request-id' header for request logging, examples here do not use it

## Set Yourself Up for making HTTP calls to AMS:

#### Step 0 Create an Azure Media Services account using the Azure Portal

Use the Azure portal to create an Azure Media Services account, as explained [here](http://azure.microsoft.com/en-us/documentation/articles/media-services-create-account/)

#### Step 1 - Get an access token

###### Http Request

```
POST /v2/OAuth2-13 HTTP/1.1
Host: wamsprodglobal001acs.accesscontrol.windows.net
Content-Type: application/x-www-form-urlencoded
Content-Length: 120
Expect: 100-continue
Connection: Keep-Alive
Accept: application/json
Cache-Control: no-cache
Postman-Token: 25a3c853-d004-b0d4-2c52-a7e2fb4d3745

grant_type=client_credentials&client_id=testams&client_secret={{your_url_encoded_ams_key_here}}&scope=urn%3AWindowsAzureMediaServices
```

##### Http Response

```
{
"token_type": "http://schemas.xmlsoap.org/ws/2009/11/swt-token-profile-1.0",
"access_token": "http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1432165204&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=lWkRuaUeKz%2bTcDoD4zC9DGthFpSwhkiZrBQgGlgj4Vg%3d",
"expires_in": "21600",
"scope": "urn:WindowsAzureMediaServices"
}
```

##### Notes

1. Value of 'client_id' in request body is your Azure Media Services account name - retrieve it from the Azure Portal using the 'Manage Keys' button
2. Value of 'client_secret' in request body is *_URL encoded_* your Azure Media Services key - retrieve it from the Azure Portal using the 'Manage Keys' button
3. Value of 'access_token' in response is time sensitive, see the 'expires_in' item in response, which is in seconds. You will need this access token in ALL calls to Azure Media Services below. As you navigate through these samples, if the token expires, you will have to repeat this step to generate a fresh access token to continue, and use the fresh token for subsequent calls
4. Consistent with the Content-Type header, note that the value of 'scope' in the request body is also URL encoded. In fact, the entire request body must be URL encoded

#### Step 2 - Connect to AMS using the token to (a) discover metadata to test the token out (b) get the cloud service URL for subsequent calls

###### Http Request

```
GET / HTTP/1.1
Host: media.windows.net
Authorization: Bearer http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1431922792&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=sQP7FQdUX5lt7HIg1pHoALLvBgn0l8mmE0MkUQfLSKA%3d
x-ms-version: 2.9
Accept: application/json
DataServiceVersion: 3.0
MaxDataServiceVersion: 3.0
Cache-Control: no-cache
Postman-Token: 45341887-870c-55e7-3869-0ac02e05271b
```

###### Http Response

```
{
"odata.metadata": "https://wamsbluclus001rest-hs.cloudapp.net/api/$metadata",
"value": [
{
"name": "AccessPolicies",
"url": "AccessPolicies"
},
{
"name": "Locators",
"url": "Locators"
},
{
"name": "ContentKeys",
"url": "ContentKeys"
},
{
"name": "ContentKeyAuthorizationPolicyOptions",
"url": "ContentKeyAuthorizationPolicyOptions"
},
{
"name": "ContentKeyAuthorizationPolicies",
"url": "ContentKeyAuthorizationPolicies"
},
{
"name": "Files",
"url": "Files"
},
{
"name": "Assets",
"url": "Assets"
},
{
"name": "AssetDeliveryPolicies",
"url": "AssetDeliveryPolicies"
},
{
"name": "IngestManifestFiles",
"url": "IngestManifestFiles"
},
{
"name": "IngestManifestAssets",
"url": "IngestManifestAssets"
},
{
"name": "IngestManifests",
"url": "IngestManifests"
},
{
"name": "StorageAccounts",
"url": "StorageAccounts"
},
{
"name": "Tasks",
"url": "Tasks"
},
{
"name": "NotificationEndPoints",
"url": "NotificationEndPoints"
},
{
"name": "Jobs",
"url": "Jobs"
},
{
"name": "TaskTemplates",
"url": "TaskTemplates"
},
{
"name": "JobTemplates",
"url": "JobTemplates"
},
{
"name": "MediaProcessors",
"url": "MediaProcessors"
},
{
"name": "EncodingReservedUnitTypes",
"url": "EncodingReservedUnitTypes"
},
{
"name": "Operations",
"url": "Operations"
},
{
"name": "StreamingEndpoints",
"url": "StreamingEndpoints"
},
{
"name": "Channels",
"url": "Channels"
},
{
"name": "Programs",
"url": "Programs"
}
]
}
```

##### Notes

1. Though you sent this request to 'media.windows.net', you should not send subsequent requests to AMS to this host. You should use the hostname returned in this response ('wamsbluclus001rest-hs.cloudapp.net' in this example) from here on
2. The value of the 'Authorization' header uses the access token. Note the word 'Bearer' followed by a space must precede the access token. Also note that if ther access token has expired, you will have to re-issue a new one by repeating Step 1

## Create an AMS 'Asset' and associated resource objects:

#### Step 3 - Create an Asset

###### Http Request

```
POST /api/Assets HTTP/1.1
Host: wamsbluclus001rest-hs.cloudapp.net
Content-Type: application/json
DataServiceVersion: 1.0;NetFx
MaxDataServiceVersion: 3.0;NetFx
Accept: application/json
Accept-Charset: UTF-8
Authorization: Bearer http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1431922792&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=sQP7FQdUX5lt7HIg1pHoALLvBgn0l8mmE0MkUQfLSKA%3d
x-ms-version: 2.8
Cache-Control: no-cache
Postman-Token: 611b299d-ea2d-f8c8-d65c-87f9bdf74f8a

{"Name":"koushik.mp4"}
```

###### Http Response

```
{
"odata.metadata": "https://wamsbluclus001rest-hs.cloudapp.net/api/$metadata#Assets/@Element",
"Id": "nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"State": 0,
"Created": "2015-05-18T02:15:19.2871684Z",
"LastModified": "2015-05-18T02:15:19.2871684Z",
"AlternateId": null,
"Name": "koushik.mp4",
"Options": 0,
"Uri": "https://testamsstorage.blob.core.windows.net/asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"StorageAccountName": "testamsstorage"
}
```

###### Notes

1. Note that we are using the hostname we received in Step 2 from here on
2. You can use the latest (as of this writing, May 2015) values of 'DataServiceVersion' and 'MaxDataServiceVersion' - '3.0'. In this example, certain older values are used
3. You can use the latest (as of this writing, May 2015) value of 'x-ms-version' - '2.9'. In this example, 2.8, on older value, is used. Be aware that functionalities change between these API versions. An example known to work with one version is not guaranteed to work with another API version
4. This call creates an AMS 'Asset' resource for you. It is empty after creation. The 'Uri' in response gives us the resource identifier for this Asset. Note that this Uri actually uses an *_Azure Storage_* name as its fqdn. This is the storage name you specified when creating the Azure Media Services account. Also note that the part after the fqdn is actually the name of a blob container created in the storage account.
5. At this stage, you can go back to the portal, browse to Storage, list your containers and see this newly created container representing the AMS Asset
6. Make a note of the 'Id' in the response. We will be using this several times below when we update or refer to this asset during subsequent operations

#### Step 4 - Create an AssetFile (metadata for Asset)

###### Http Request

```
POST /api/Files HTTP/1.1
Host: wamsbluclus001rest-hs.cloudapp.net
Content-Type: application/json
DataServiceVersion: 1.0;NetFx
MaxDataServiceVersion: 3.0;NetFx
Accept: application/json
Accept-Charset: UTF-8
Authorization: Bearer http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1431922792&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=sQP7FQdUX5lt7HIg1pHoALLvBgn0l8mmE0MkUQfLSKA%3d
x-ms-version: 2.8
Cache-Control: no-cache
Postman-Token: a1d1ea60-21c4-5ab3-f434-3f4bf7691687

{  
   "IsEncrypted":"false",
   "IsPrimary":"false",
   "MimeType":"video/mp4",
   "Name":"koushik.mp4",
   "ParentAssetId":"nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd"
}
```

###### Http Response

```
{
"odata.metadata": "https://wamsbluclus001rest-hs.cloudapp.net/api/$metadata#Assets/@Element",
"Id": "nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"State": 0,
"Created": "2015-05-18T02:15:19.2871684Z",
"LastModified": "2015-05-18T02:15:19.2871684Z",
"AlternateId": null,
"Name": "koushik.mp4",
"Options": 0,
"Uri": "https://testamsstorage.blob.core.windows.net/asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"StorageAccountName": "testamsstorage"
}
```

###### Notes

1. Note that we are using the hostname we received in Step 2
2. You can use the latest (as of this writing, May 2015) values of 'DataServiceVersion' and 'MaxDataServiceVersion' - '3.0'. In this example, certain older values are used
3. You can use the latest (as of this writing, May 2015) value of 'x-ms-version' - '2.9'. In this example, 2.8, on older value, is used. Be aware that functionalities change between these API versions. An example known to work with one version is not guaranteed to work with another API version
4. This call creates an AMS 'AssetFile' resource for you and associates that with the 'Asset' object created in Step 3. This happens because you specify the id of the asset created in step 3 ('Id' field from Step 3's response) in the 'ParentAssetId' field of this Request
5. Make a note of the 'Id' in the response. We will be using this below when we update the metadata later
