#A simple script that reads a list of IP addresses (one per line), say from the talos banlist, queries your elasticsearch and index, if found it reports the results to you.

#blocklist IPs found text file creation
$date = Get-Date -Format yyyyMMdd 
$addToBlocklist = $date + 'blocklist.txt'
New-Item -Path "'.\$addToBlocklist'" -ItemType File -ErrorAction SilentlyContinue

#Fill in elasticsearch ip address and index
$elasticURI = "http://localhost:9200/filebeat-*/_search?pretty"

#build the json object for the web request against the desired index in 
Get-Content .\ip_filter_20200825talosblack.txt | ForEach-Object {
    $ipString = '"' + $_ + '"'
    $elasticQuery = @"
    {
        "query": {
            "bool": {
                "filter": [
                    {
                    "terms": {
                        "source.address": [
                            ${ipString}
                        ]
                    }
                    }
                ]
            }
        }
        }
"@
#Query the elasticsearch server and check for the presence of blocklist IPs
$request = Invoke-WebRequest -Headers @{'Content-Type'= 'application/json; charset=utf-8'} -Uri $elasticURI -method POST -Body $elasticQuery | ConvertFrom-Json

#grab the results
$ipFound = $request.hits.total.value

If ($ipFound -ne 0){
    Write-Host $_ ' found, adding to blocklist.'
    Add-Content $addToBlocklist $_
    Write-Host 'IP added to the list.'
}

#Pause briefly to keep from overwhelming elasticsearch with queries, tweak as appropriate for our environment
Start-Sleep -Milliseconds 1
}