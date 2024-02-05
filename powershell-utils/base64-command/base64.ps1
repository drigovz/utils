function base64 {
    param(
        [string]$f
    )

    $word = $f

    if ([string]::IsNullOrEmpty($word)) {
        Write-Host "`nWord not valid!" -ForegroundColor "Red"
    } else {
        $encrypted = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($word.Trim()))

        Write-Host "$encrypted"
    }
}

# Add this funtion on custom module, and call
#   base64 -f word-to-encripted
# on cli