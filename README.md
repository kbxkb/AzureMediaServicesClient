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
2. The value of the 'Authorization' header uses the access token. Note the word 'Bearer' followed by a space must precede the access token. Also note that if the access token has expired, you will have to re-issue a new one by repeating Step 1

## Create an AMS 'Asset' and associated resources:

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
4. This call creates an AMS 'Asset' resource for you. It is empty after creation. The 'Uri' in response gives us the resource identifier for this Asset. Note that this Uri actually uses an *_Azure Storage Account_* name as its fqdn. This is the storage account name you specified when creating the Azure Media Services account. Also note that the part after the fqdn is actually the name of a blob container created in the storage account
5. At this stage, you can go back to the portal, browse to Storage, list your containers and see this newly created container representing the AMS Asset
6. The REQUEST body shown here is minimal. There are other things you can specify, for a complete list see the [REST API reference for Azure Media Services](https://msdn.microsoft.com/en-us/library/azure/hh973617.aspx). Specifically, all properties of the Asset entity are listed [here](https://msdn.microsoft.com/en-us/library/azure/hh974277.aspx#asset_entity_properties) - an interesting one is 'Options', whose default value is 0 (meaning that the asset will not be encrypted) - that is what we have used here. You can have values of 1, 2 or 4 specifying different encryption schemes. If you encrypt your asset, you will have to call several other REST API-s not shown in this tutorial to enable its delivery and decryption
7. Make a note of the 'Id' in the response. We will be using this several times below when we update or refer to this asset during subsequent operations

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
"odata.metadata": "https://wamsbluclus001rest-hs.cloudapp.net/api/$metadata#Files/@Element",
"Id": "nb:cid:UUID:9412435d-1500-80c3-1118-f1e4fd04ed00",
"Name": "koushik.mp4",
"ContentFileSize": "0",
"ParentAssetId": "nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"EncryptionVersion": null,
"EncryptionScheme": null,
"IsEncrypted": false,
"EncryptionKeyId": null,
"InitializationVector": null,
"IsPrimary": false,
"LastModified": "2015-05-18T02:24:01.1515399Z",
"Created": "2015-05-18T02:24:01.1515399Z",
"MimeType": "video/mp4",
"ContentChecksum": null
}
```

###### Notes

1. Note that we are using the hostname we received in Step 2
2. You can use the latest (as of this writing, May 2015) values of 'DataServiceVersion' and 'MaxDataServiceVersion' - '3.0'. In this example, certain older values are used
3. You can use the latest (as of this writing, May 2015) value of 'x-ms-version' - '2.9'. In this example, 2.8, on older value, is used. Be aware that functionalities change between these API versions. An example known to work with one version is not guaranteed to work with another API version
4. This call creates an AMS 'AssetFile' resource for you and associates that with the 'Asset' object created in Step 3. This happens because you specify the id of the asset created in step 3 ('Id' field from Step 3's response) in the 'ParentAssetId' field of this Request
5. Make a note of the 'Id' in the response. We will be using this below when we update the metadata later

## Prepare to upload your media file to your Asset:

#### Step 5 - Create an Access Policy for writing into blob storage

###### Http Request

```
POST /api/AccessPolicies HTTP/1.1
Host: wamsbluclus001rest-hs.cloudapp.net
Content-Type: application/json
DataServiceVersion: 3.0
MaxDataServiceVersion: 3.0
Accept: application/json;odata=verbose
Accept-Charset: UTF-8
Authorization: Bearer http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1431938655&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=x4V9XC21vgwqNkb974nxmYjTIQ4%2b1xK8ororQcN7HFY%3d
x-ms-version: 2.9
Expect: 100-continue
Cache-Control: no-cache
Postman-Token: bdf2fe4b-fa7b-88cf-a7db-27bdef643fe6

{"Name": "KoushikPolicy", "DurationInMinutes" : "43200", "Permissions" : 2 }
```

###### Http Response

```
{
"d": {
"__metadata": {
"id": "https://wamsbluclus001rest-hs.cloudapp.net/api/AccessPolicies('nb%3Apid%3AUUID%3Acb227956-91d8-441c-946b-0130479508f5')",
"uri": "https://wamsbluclus001rest-hs.cloudapp.net/api/AccessPolicies('nb%3Apid%3AUUID%3Acb227956-91d8-441c-946b-0130479508f5')",
"type": "Microsoft.Cloud.Media.Vod.Rest.Data.Models.AccessPolicy"
},
"Id": "nb:pid:UUID:cb227956-91d8-441c-946b-0130479508f5",
"Created": "\/Date(1431917232698)\/",
"LastModified": "\/Date(1431917232698)\/",
"Name": "KoushikPolicy",
"DurationInMinutes": 43200,
"Permissions": 2
}
}
```

###### Notes

1. An access policy is required to create a Locator. A Locator is required to get an upload URL that we will use to upload our media file. We will create a Locator next
2. Note that the access policy will be in effect until it expires - and we specify the duration in minutes in the REQUEST JSON
3. Note that the 'Permissions' field in REQUEST JSON has possible values of 0, 1, 2, 4 and 8 - please see [here](https://msdn.microsoft.com/library/azure/hh974297.aspx#accesspolicy_properties) for the API reference and all possible values/meanings
4. Make a note of the 'Id' in the response. We will be using this when we refer to this access policy in subsequent calls

#### Step 6 - Create a Locator of Type 1 (SAS) for uploading a media file:

###### Http Request

```
POST /api/Locators HTTP/1.1
Host: wamsbluclus001rest-hs.cloudapp.net
Content-Type: application/json
DataServiceVersion: 3.0
MaxDataServiceVersion: 3.0
Accept: application/json
Accept-Charset: UTF-8
Authorization: Bearer http%3a%2f%2fschemas.xmlsoap.org%2fws%2f2005%2f05%2fidentity%2fclaims%2fnameidentifier=testams&urn%3aSubscriptionId=21bb6118-8aa3-4408-adbb-b057912c24b6&http%3a%2f%2fschemas.microsoft.com%2faccesscontrolservice%2f2010%2f07%2fclaims%2fidentityprovider=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&Audience=urn%3aWindowsAzureMediaServices&ExpiresOn=1431939893&Issuer=https%3a%2f%2fwamsprodglobal001acs.accesscontrol.windows.net%2f&HMACSHA256=Eh6h09tQCsgSh0FLBA77G6wxKYh55KBGri7L87kSBF8%3d
x-ms-version: 2.9
Cache-Control: no-cache
Postman-Token: ec29dc11-7646-329f-5adc-4075c9456b61

{"AccessPolicyId": "nb:pid:UUID:cb227956-91d8-441c-946b-0130479508f5", "AssetId" : "nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd", "StartTime" : "2015-05-17T22:00:00", "Type":1}
```

###### Http Response

```
{
"odata.metadata": "https://wamsbluclus001rest-hs.cloudapp.net/api/$metadata#Locators/@Element",
"Id": "nb:lid:UUID:141ea923-ae46-41c4-9408-55c5ebc41938",
"ExpirationDateTime": "2015-06-16T22:00:00",
"Type": 1,
"Path": "https://testamsstorage.blob.core.windows.net/asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd?sv=2012-02-12&sr=c&si=141ea923-ae46-41c4-9408-55c5ebc41938&sig=AQNVV2VP%2B4XKt5PQHtwDOhQnF0yfXKmp31f9CbRAlfY%3D&st=2015-05-17T22%3A00%3A00Z&se=2015-06-16T22%3A00%3A00Z",
"BaseUri": "https://testamsstorage.blob.core.windows.net/asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"ContentAccessComponent": "?sv=2012-02-12&sr=c&si=141ea923-ae46-41c4-9408-55c5ebc41938&sig=AQNVV2VP%2B4XKt5PQHtwDOhQnF0yfXKmp31f9CbRAlfY%3D&st=2015-05-17T22%3A00%3A00Z&se=2015-06-16T22%3A00%3A00Z",
"AccessPolicyId": "nb:pid:UUID:cb227956-91d8-441c-946b-0130479508f5",
"AssetId": "nb:cid:UUID:cc27435d-1500-80c3-5690-f1e4fd03b5fd",
"StartTime": "2015-05-17T22:00:00",
"Name": null
}
```

###### Notes

1. This step is necessary to get the actual upload URL that we will use to upload our content file to AMS. The 'Path' and 'BaseUri' elements in the RESPONSE JSON will help us create the actual upload URL next
2. Note that in the REQUEST JSON, we are specifying the 'AccessPolicyId' from the 'Id' field in the response from Step 5, and 'AssetId' from the 'Id' field in the response from Step 3
3. Note that in the REQUEST JSON, we are specifying 'StartTime'. In order to avoid confusion, you can use UTC time and append a 'Z' to the time string - like this: "2015-05-17T22:00:00Z". Note that this can be (and should be, unless you have a reason to create a locator that you want to be activated in the future) a time in the past. If you use the exact current time, your locator may not be active until a few minutes, because Azure servers are not time-synced with your machine
4. Note that in the REQUEST JSON, we are specifying 'Type' as 1 - see [here](https://msdn.microsoft.com/library/azure/hh974308.aspx#locator_entity_properties) for all possible values and meanings. In short, use 1 for SAS type of locators, and use 2 for On Demand type of locators
5. The 'Id' field in the RESPONSE JSON gives the locator's id
6. We will use the 'Path' field in this RESPONSE JSON to construct the upload URL and access Azure Blob Storage next

## Upload your media file:

#### Step 7 - Upload a media file to the blob storage associated with the AMS account:

###### Http Request

```
PUT /asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd/koushik.mp4 HTTP/1.1
Host: testamsstorage.blob.core.windows.net
x-ms-version: 2012-02-12
Date: Tue, 19 May 2015 16:46:08 GMT
x-ms-date: Tue, 19 May 2015 16:46:08 GMT
Content-Type: application/octet-stream
x-ms-blob-type: BlockBlob
Authorization: SharedKey testamsstorage:kFH6XA+GBujEQNfr19MLkdbpHsEwOFgqRIgQ1ghAti0=
Content-Length: 10498677
Cache-Control: no-cache
Postman-Token: e62793bc-2219-a563-2beb-4e7a20815305

{{POST Body was the binary mp4 file koushik.mp4}}
```

###### Http Response

```
{{No response body, just 201 created}}
```

###### Notes

1. This is a request to Azure storage (as opposed to Azure Media Services, which all other calls in this tutorial are)
2. See all supported request headers [here](https://msdn.microsoft.com/en-us/library/azure/dd179451.aspx) - in the section 'Request Headers (Block and Page Blobs'
3. The upload URL is constructed from the 'Path' field of the response from Step 6 (where we created the locator). Drop everything from '?' onwards, just take the URL without query strings. Append "/" and then the name of the MP4 file (e.g., "/koushik.mp4" above)
4. The value of x-ms-version header should be the value of "sv" query string parameter from the "Path" field of the response from Step 6 (where we created the locator)
5. The value of Content-Length header should be the exact size of the MP4 file in bytes
6. The value of the signature inside the Authorization Header needs to be calculated as per guidance [here](https://msdn.microsoft.com/en-us/library/azure/dd179428.aspx) - however, the guidance can quickly get pretty confusing. Hence, I am going to show a more straightforward way here
7. In order to get the signature inside the Authorization header, use this Power Shell script. It has no dependencies, no snap-ins required, just run it after changing the hardcoded values to whatever they are in your case - see the next point for a detailed description of what to change and how to use it. It will print out 2 things - The UTC time and the signature. Copy the UTC time in the "Date" and "x-ms-date" headers, and copy the signature into the Authorization header after the colon
8. Power shell script to output date and signture:

```
function Generate-AuthString
{
	param(
		 [string]$accountName
		,[string]$accountKey
        ,[string]$containerAndBlobPath
		,[string]$requestUtcTime
        ,[string]$contentLength
        ,[string]$contentType
	) 

	$authString =  "PUT$([char]10)$([char]10)$([char]10)"
    $authString += $contentLength + "$([char]10)$([char]10)"
    $authString += $contentType + "$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)"
    $authString += "x-ms-blob-type:" + "BlockBlob" + "$([char]10)"
	$authString += "x-ms-date:" + $requestUtcTime + "$([char]10)"
	$authString += "x-ms-version:2012-02-12" + "$([char]10)"
    $authString += "/" + $accountName + "/" + $containerAndBlobPath
	
	$dataToMac = [System.Text.Encoding]::UTF8.GetBytes($authString)

	$accountKeyBytes = [System.Convert]::FromBase64String($accountKey)

	$hmac = new-object System.Security.Cryptography.HMACSHA256((,$accountKeyBytes))
	[System.Convert]::ToBase64String($hmac.ComputeHash($dataToMac))
}

$accountName = "testamsstorage"
$accountKey = "r7g8b6tgYYG9K4i7c3bX0FdFykpOpJ0e1n4GSa2yHWs1ddCKdSfhxKK06wxxGaymsI91eSLMDvVR7UMdo68WJQ=="
$resourcePath = "asset-cc27435d-1500-80c3-5690-f1e4fd03b5fd/koushik.mp4"
$fileSize = "10498677"
$ContentTypeHeader = "application/octet-stream"

$timeNow = [System.DateTime]::UtcNow.ToString("R")
$authHeader = Generate-AuthString -requestUtcTime $timeNow -containerAndBlobPath $resourcePath -accountName $accountName -accountKey $accountKey -contentLength $fileSize -contentType $ContentTypeHeader

Write-Output $timeNow
Write-Output $authHeader
```
9. How to use this Power Shell script:
- Replace the value of the variable $accountName with your STORAGE account name. Hint: Your storage account name is the first segment of the "Path" in Locator Creation Response after the pair of forward slashes and before ".blob.core.windows.net". Also, log into the portal and click on "Storage", locate the storage account associated with your AMS account, click on "Manage Keys" and it will show your storage account name
- Replace the value of $accountKey with your STORAGE account key. Log into the portal and click on "Storage", locate the storage account associated with your AMS account, click on "Manage Keys" and it will show your storage account key (choose either the primary or the secondary key)
- Replace the value of $resourcePath with your own - it is basically the URL from "Path" in Locator Creation Response. Drop everything from '?' onwards, just take the URL without query strings. Append "/" and then the name of the MP4 file (e.g., "/koushik.mp4" above)
- Replace the value of $fileSize with the exact size of the MP4 file in bytes
- Run it. It will print out 2 things - The UTC time and the signature. Copy the UTC time in both the "Date" and "x-ms-date" headers, and copy the signature into the Authorization header after the colon. You have to fire off the HTTP request within 15 minutes of generating the signature using the script, otherwise you will get a 4XX response
