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
$authHeader = Generate-AuthString -requestUtcTime $timeNow -containerAndBlobPath $resourcePath -accountName $accountName -accountKey $accountKey 
-contentLength $fileSize -contentType $ContentTypeHeader

Write-Output $timeNow
Write-Output $authHeader