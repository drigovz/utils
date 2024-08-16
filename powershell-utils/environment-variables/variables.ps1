$variableName = Read-Host "Variable name "
$variableValue = Read-Host "Variable value "

if ([string]::IsNullOrEmpty($variableName) || [string]::IsNullOrEmpty($variableValue)) {
    Write-Host "`nName or value not valid!" -ForegroundColor "Red"
    Exit
} else {
    [System.Environment]::SetEnvironmentVariable("$variableName", "$variableValue", [System.EnvironmentVariableTarget]::Machine)

    [System.Environment]::GetEnvironmentVariable("$variableName", 'Machine')
}
