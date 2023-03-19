$user = $env:UserName
$dateTime = (Get-Date).ToString('dd-MM-yyyy-hh-mm')
$dropLogFileName = "drop_log_$dateTime.txt"
$cloneLogFileName = "clone_log_$dateTime.txt"
$db = Read-Host "What is database to clone"

if ([string]::IsNullOrEmpty($db)) {
    Write-Host "`nDatabase name not valid!" -ForegroundColor "Red"
}
else {
    $databaseCloneName = "$($db)_Clone"

    # db ="'$db'" ==>> pass variable value to sql script, and the double ' is because variable passade is string on SQL script
    sqlcmd -S "(LocalDB)\MSSQLLocalDB" -E -v db ="'$databaseCloneName'" -i .\scripts\drop_database.sql -o ".\logs\$dropLogFileName"

    if (Test-Path "C:\Users\$user\$db.dat") {
        Remove-Item "C:\Users\$user\$db.dat" | out-null
    }

    if (Test-Path "C:\Users\$user\$databaseCloneName.mdf") {
        Remove-Item "C:\Users\$user\$databaseCloneName.mdf" | out-null
    }

    if (Test-Path "C:\Users\$user\$databaseCloneName.ldf") {
        Remove-Item "C:\Users\$user\$databaseCloneName.ldf" | out-null
    }

    sqlcmd -S "(LocalDB)\MSSQLLocalDB" -E -v db ="'$db'" -i .\scripts\clone_database.sql -o ".\logs\$cloneLogFileName"
}
