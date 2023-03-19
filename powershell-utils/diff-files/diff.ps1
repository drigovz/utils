

$inputFile = Read-Host "What is reference file? "
$inputCompareFile = Read-Host "What is file to compare? "

if ([string]::IsNullOrEmpty($inputFile) || [string]::IsNullOrEmpty($inputCompareFile)) {
    Write-Host "`nInput file not found!" -ForegroundColor "Red"
    Exit
} else {
    $ReferenceObject = (Get-Content -Path "$inputFile")
    $DifferenceObject = (Get-Content -Path "$inputCompareFile")

    Compare-Object $ReferenceObject $DifferenceObject -IncludeEqual -CaseSensitive
}
