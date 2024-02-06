function convert-base64 {
    param(
        [string]$f
    )

    $user = $env:UserName
    $date = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
    $filename = "C:\Users\$user\Downloads\file_$date.pdf"
    $filePath = $f
    $base64 = Get-Content -Path $f

    if (-not(Test-path $filePath -PathType leaf)) {
        Write-Host "`nFile not found!" -ForegroundColor "Red"
    } else {
        $bytes = [Convert]::FromBase64String($base64)
        [IO.File]::WriteAllBytes($filename, $bytes)
    }
}
