#!/bin/sh

# run this script to up the containers to create an instance of SQL Server and Redis 
# together with the network for development
userLogged=$USER
YELLOW="\e[33m"
GREEN="\e[32m"
CYAN="\e[36m"
LIGHTYELLOW="\e[95m"
ENDCOLOR="\e[0m"
dotnetPath="/home/$userLogged/Dev/dotnet-environment/dotnet"
sqlPath="/home/$userLogged/Dev/dotnet-environment/mssql"
redisPath="/home/$userLogged/Dev/dotnet-environment/redisdb"

# check dotnet path exists
echo "${YELLOW}Checking .NET Core directory!${ENDCOLOR}" 
if [ -d $dotnetPath ]
then
    echo "${GREEN}OK${ENDCOLOR}"
else
    echo "${CYAN}Creating .NET Core directory!${ENDCOLOR}"
    mkdir -p $dotnetPath
    echo "${LIGHTYELLOW}Change recursive mode owner of .NET Core directory!${ENDCOLOR}"
    sudo chown -R $userLogged $dotnetPath
    # alter permissions to read, write and execute files
    sudo chmod -R 777 $dotnetPath
fi

# check SQL Server path exists
echo "${YELLOW}Checking SQL Server directory!${ENDCOLOR}" 
if [ -d $sqlPath ]
then
    echo "${GREEN}OK${ENDCOLOR}"
else
    echo "${CYAN}Creating SQL Server directory!${ENDCOLOR}"
    mkdir -p $sqlPath
    echo "${LIGHTYELLOW}Change recursive mode owner of SQL Server directory!${ENDCOLOR}"
    sudo chown -R $userLogged $sqlPath
fi

# check Redis path exists
echo "${YELLOW}Checking Redis directory!${ENDCOLOR}" 
if [ -d $redisPath ]
then
    echo "${GREEN}OK${ENDCOLOR}"
else
    echo "${CYAN}Creating Redis directory!${ENDCOLOR}"
    mkdir -p $redisPath
    echo "${LIGHTYELLOW}Change recursive mode owner of Redis directory!${ENDCOLOR}"
    sudo chown -R $userLogged $redisPath
fi

# create devlx-network
docker network create --driver bridge devlx-network

# create containers of SQL Server, RedisInsight and Redis
docker-compose up -d

# create container of .NET Core and connect on network-devlx network
# sudo docker run --privileged --name dotnet --rm --volume $dotnetPath":/srv/app" --workdir "/srv/app" -p 5000:5000 -p 5001:5001 -it --network devlx-network mcr.microsoft.com/dotnet/sdk:3.1 bash
docker exec -it dotnet bash

# When to create a folder inside container, remember to run command:
# chmod -R 777 folder_name
# to add permissions to Read, Write and Execute files and paths
# every time to create a new file or path with command line inside container, you need to change permissions

# to run this app, change the applicationUrl on Properties/launchSettings.json file
# "applicationUrl": "https://0.0.0.0:5001;http://0.0.0.0:5000"
# access https://localhost:5001/