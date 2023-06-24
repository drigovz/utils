# run on root directory of project 
$env = 'Local' 
$applicationName = Read-Host "What is application name"

if ([string]::IsNullOrEmpty($applicationName)) {
    Write-Host "`nName not valid!" -ForegroundColor "Red"
} else {
    $migrationName = Read-Host "What is migration name"

    if ([string]::IsNullOrEmpty($migrationName)) {
        Write-Host "`nName not valid!" -ForegroundColor "Red"
    } else {
        cd $applicationName

        $env:ASPNETCORE_ENVIRONMENT=$env
        dotnet ef --startup-project ".\$applicationName.Api" migrations add $migrationName --project ".\$applicationName.Infra" --output-dir .\Migrations\

        $updateDb = Read-Host "Would you like to apply migrations? `n   Y) YES `n   N) NO "

        $updateDbUpper = (Get-Culture).TextInfo.ToTitleCase("$updateDb")

        if ($updateDbUpper -eq "Y") {
            $env:ASPNETCORE_ENVIRONMENT=$env
            dotnet ef --startup-project ".\$applicationName.Api" database update
        } else {
            Write-Host "`nExecution was canceled!" -ForegroundColor "Red"
        }
    }
}