param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Password
)

# Outputs a "sha256:<hex>" value ready to paste into users.json
$bytes = [Text.Encoding]::UTF8.GetBytes($Password)
$hash = [Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
$hex = -join ($hash | ForEach-Object { $_.ToString('x2') })
Write-Output ("sha256:" + $hex)
