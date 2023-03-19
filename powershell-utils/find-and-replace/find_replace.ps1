$user = $env:UserName;
$oldValue = Read-Host "Hi $user, what is the word that you would like to replace? ";
$newValue = Read-Host "Replace to? ";

# replace folders
Get-ChildItem $currentLocation -R | Rename-Item -NewName { $_.Name -creplace $oldValue, $newValue }

$currentLocation = Get-Location;
Get-ChildItem $currentLocation -Recurse;

# replace inside files
foreach ($file in Get-ChildItem $currentLocation -Recurse) {
    # if not is powershell file
    if (-not  ($file.Extension -eq '.ps1')) {
        # if not is folder
        if (-not $file.PSIsContainer) {
            ((Get-Content -Path $file.FullName -Raw) -creplace $oldValue, $newValue) | Set-Content -Path $file.FullName
        }
    }
}

# [Environment]::Exit(1)