# get public IP address
$publicIp = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()

Write-Host $publicIp