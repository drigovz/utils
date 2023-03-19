# run this script to up the containers to create an instance of SQL Server and Redis 
# together with the network for development

# development environment on Windows 
$dotnetPath = "C:\dev\dotnet-environment\dotnet"
$sqlPath = "C:\dev\dotnet-environment\mssql"
$redisPath = "C:\dev\dotnet-environment\redisdb"

# check dotnet path exists
Write-Host "Checking .NET Core directory!" -ForegroundColor "Yellow" 
If (Test-Path -Path $dotnetPath) {
    # Write-Host "Directory " $dotnetPath " already exists!" -ForegroundColor "Green"
    Write-Host "OK" -ForegroundColor "Green"
} else {
    Write-Host "Creating .NET Core directory!" -ForegroundColor "Cyan"
    mkdir -p $dotnetPath
}

# check SQL Server path exists
Write-Host "Checking SQL Server directory!" -ForegroundColor "Yellow" 
If (Test-Path -Path $sqlPath) {
    Write-Host "OK" -ForegroundColor "Green" 
} else {
    Write-Host "Creating SQL Server directory!" -ForegroundColor "Cyan"
    mkdir -p $sqlPath
}

# check Redis path exists
Write-Host "Checking Redis directory!" -ForegroundColor "Yellow" 
If (Test-Path -Path $redisPath) {
    Write-Host "OK" -ForegroundColor "Green"
} else {
    Write-Host "Creating Redis directory!" -ForegroundColor "Cyan"
    mkdir -p $redisPath
}

# create dev-network
docker network create --driver bridge dev-network

# create containers of SQL Server, RedisInsight and Redis
docker-compose up -d

# create container of .NET Core and connect on network-dev network
# docker run  --name dotnet --rm --volume $dotnetPath":/srv/app" --workdir "/srv/app" -p 8080:80 -it --network dev-network mcr.microsoft.com/dotnet/sdk:3.1 bash
docker exec -it dotnet bash

# to run this app, change the applicationUrl on Properties/launchSettings.json file
# "applicationUrl": "https://0.0.0.0:5001;http://0.0.0.0:5000"
# access https://localhost:5001/