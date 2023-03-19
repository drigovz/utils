$user = $env:UserName
Write-Host "Hello $user!"

# init configuration
$email = Read-Host "What is your email? ";
if ([string]::IsNullOrEmpty($email)) {
    Write-Host "Email not valid!";
}
else {
    Write-Host "Your email is $email";

    # install 7Zip
    choco install 7zip -y


    # install chocolatey
    # iex
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    # check installation
    choco --version


    # install Node.js LTS
    choco install nodejs-lts -y
    node --version
    npm --version
    npx --version


    # install yarn package manager
    npm install -g yarn
	
	
	# install Typescript
	npm install -g typescript


    # install git
    choco install git --params "/NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration" -y

    git --version

    $nameGit = Read-Host "What is your Git username? ";
    if ([string]::IsNullOrEmpty($nameGit)) {
        Write-Host "username not valid! $user will be used!";
        git config --global user.name "$user"
    } else {
        git config --global user.name "$nameGit"
    }

    git config --global user.email $email
    git config --global core.editor notepad
    git config --global init.defaultbranch main
    git config --global core.autocrlf false

    git config --global alias.cf config
    git config --global alias.co checkout
    git config --global alias.s status
    git config --global alias.b branch
    git config --global alias.c commit
    git config --global alias.a add
    git config --global alias.l log
    git config --global alias.rl reflog
    git config --global alias.d diff
    git config --global alias.rs reset
    git config --global alias.r remote
    git config --global alias.ps push
    git config --global alias.p pull
    git config --global alias.m merge
    git config --global alias.cp cherry-pick
    git config --global alias.rb rebase


    # vim
    choco install vim --params "/NoDefaultVimrc /NoContextmenu /NoDesktopShortcuts" -y


    # install dotnet
    choco install dotnet -y


    # install vs code
    choco install --params "/NoDesktopIcon /NoQuicklaunchIcon" vscode -y


    # install docker
    # choco install docker-desktop -y


    # install Golang
    choco install golang


    # install firefox
    choco install firefox --params "/l:pt-BR /NoDesktopShortcut /NoStartMenuShortcut" -y


    # install powershell core
    choco install powershell-core -y


    # install Windows Terminal
    choco install microsoft-windows-terminal -y


    # install cli tools
    choco install lazygit -y
    choco install bat -y
    choco install bottom -y


    # install powertoys
    choco install powertoys -y
}

# finish
exit