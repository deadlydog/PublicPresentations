$url = 'https://dogapi.dog/api/v2/facts?limit=3'

try {
	$restResponse = Invoke-RestMethod -Uri $url
	# $restResponse.data[0].attributes.body

	foreach ($fact in $restResponse.data) {
		Write-Output $fact.attributes.body
	}
}
catch {
	Write-Error "Error invoking REST method: $_"
}

#------------------------------------------------
# Example of using Invoke-WebRequest to get the same data.

$headers = @{
	'Accept' = 'application/json'
}
$webResponse = Invoke-WebRequest -Uri $url -Headers $headers

if ($webResponse.StatusCode -eq 200) {
	$decodedContent = [Text.Encoding]::UTF8.GetString($webResponse.Content)

	$object = $decodedContent | ConvertFrom-Json
	$object.data | ForEach-Object {
		$_.attributes.body
	}

	# Alternatively, you can use a pipeline to extract the desired property.
	$decodedContent |
		ConvertFrom-Json |
		Select-Object -ExpandProperty data |
		Select-Object -ExpandProperty attributes |
		Select-Object -ExpandProperty body
}
else {
	Write-Error "Failed to retrieve data. Status code: $($webResponse.StatusCode)"
}

#------------------------------------------------
# Example of using curl to get the same data.

$breeds = Invoke-RestMethod -Uri 'https://dogapi.dog/api/v2/breeds?page%5Bsize%5D=3'
$breeds.data | ForEach-Object {
	$_.attributes
}

curl.exe 'https://dogapi.dog/api/v2/breeds?page%5Bsize%5D=3' |
	ConvertFrom-Json |
	Select-Object -ExpandProperty data |
	Select-Object -ExpandProperty attributes
