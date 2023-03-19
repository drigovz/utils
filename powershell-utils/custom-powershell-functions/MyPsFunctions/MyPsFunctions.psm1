<#
    .SYNOPSIS
    This script contains a serie of util functions to use in your routine
    
    .AUTHOR
   Rodrigo Vaz
#>

# clean recycle bin
function myps_clean {
    $Recycler = (New-Object -ComObject Shell.Application).NameSpace(0xa)
    $Recycler.items() | ForEach-Object { Remove-Item $_.path -force -recurse }

    Write-Host "Recycle bin cleaned!!!"  -ForegroundColor "Green"
}

# delete logs and temp files
function myps_clean_temps {
    # folders to delete temp files
    $Paths = "C:\Users\drigo\AppData\Local\Temp\", "C:\Windows\Temp\"

    # if you want set extensions of files to delete
    #$Extensions = "*", "*.temp", "*.tmp", "*.log", "*.cpuprofile", "*.txt"

    # days with to keep in log folder
    $nDays = 0

    $Files = Get-ChildItem $Paths -Include "*" -Force -Recurse | Where-Object { $_.LastWriteTime -le (Get-Date).AddDays(-$nDays) }
   
    foreach ($file in $Files) {        
        if ($NULL -ne $file) {
            Write-Host "delete: $file" -ForegroundColor "DarkRed"            
            Remove-Item $File.FullName | out-null
        }
    }

    Write-Host "Finished!" -ForegroundColor "Green"
}

# setup git alias and other configurations
# to run this funtion:
# myps_setup_git -gitUserName "usuario" -gitUserEmail "email"
function myps_setup_git {
    param (
        $gitUserName,
        $gitUserEmail
    )

    $path = "C:\Program Files\Git"

    If (Test-Path -Path $path) {
        Write-Host "Git installed!! " -ForegroundColor "Green"

        Init_Config_Git $gitUserName  $gitUserEmail
    }
    else {
        Write-Host "Git not installed yet!"  -ForegroundColor "Red"

        Write-Host "Installing latest version of Git with Chocolatey!" -ForegroundColor "Green"

        # installing Git with Chocolatey
        choco install git --params "/NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration"

        Write-Host "Git installed!! " -ForegroundColor "Green"
        Init_Config_Git $gitUserName  $gitUserEmail
    }
}

function Init_Config_Git {
    Write-Host "Init configuration of Git for $gitUserName ($gitUserEmail)!!" -ForegroundColor "Green"

    # version installed
    git --version

    # set global configurations
    git config --global user.name $gitUserName
    git config --global user.email $gitUserEmail
    git config --global core.editor notepad
    git config --global init.defaultbranch main
    git config --global core.autocrlf false

    # set alias for Git
    git config --global alias.g git
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
}

# export functions
Export-ModuleMember -Function myps_clean
Export-ModuleMember -Function myps_clean_temps
Export-ModuleMember -Function myps_setup_git

# call functions on the Profile Powershell file - C:\Users\user_name\Documents\PowerShell
# Import-Module MyPsFunctions