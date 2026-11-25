param(
    [Parameter(Mandatory = $true)]
    [string]$Password,

    [Parameter(Mandatory = $true)]
    [string]$Hash
)

# Checks a candidate password against a stored "sha256:<hex>" (or bare hex) value.
$expected = $Hash.Trim()
if ($expected.StartsWith('sha256:')) {
    $expected = $expected.Substring(7)
}
$bytes = [Text.Encoding]::UTF8.GetBytes($Password)
$hex = -join ([Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString('x2') })

if ($hex -ieq $expected) {
    Write-Output "MATCH - this is the password for that hash."
} else {
    Write-Output "NO MATCH - different password."
}
