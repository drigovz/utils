# First, try to remove/uninstall older .Net, if any, then install .Net 6
echo "$(tput setaf 3)Installing .Net 6$(tput sgr0)"
sudo apt remove 'dotnet*'
sudo apt remove 'aspnetcore*'
sudo apt remove 'netstandard*'
sudo rm /etc/apt/sources.list.d/microsoft-prod.list
sudo rm /etc/apt/sources.list.d/microsoft-prod.list.save
sudo apt update
sudo apt install dotnet6
