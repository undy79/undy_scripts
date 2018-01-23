$uri = "www.somedomain.something"
$webclient = New-Object System.Net.WebClient
[string] $robots = $webclient.DownloadString(“http://www.something.someone/robots.txt”)
Write-host $robots

$disallow = $robots | select-string “Disallow:” | %{$_ -replace “Disallow: “ , “http://$uri"}
$disallow

$arr = $robots -split “\n”
$arr
$arr[0]
