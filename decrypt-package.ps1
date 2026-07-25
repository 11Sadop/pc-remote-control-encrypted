param(
  [Parameter(Mandatory = $true)]
  [string]$KeyFile,

  [string]$InputFile = "pc-control-tool.tar.gz.aes256gcm",
  [string]$OutputFile = "pc-control-tool.tar.gz"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $KeyFile)) {
  throw "Key file was not found: $KeyFile"
}

$keyText = (Get-Content -Raw -LiteralPath $KeyFile).Trim()
$key = [Convert]::FromBase64String($keyText)
if ($key.Length -ne 32) {
  throw "Invalid key length. Expected a 32-byte AES-256 key encoded as Base64."
}

$payload = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $InputFile))
if ($payload.Length -lt 28) {
  throw "Encrypted payload is too short."
}

$nonce = $payload[0..11]
$tag = $payload[12..27]
$ciphertext = $payload[28..($payload.Length - 1)]
$plaintext = New-Object byte[] $ciphertext.Length

$aes = [Security.Cryptography.AesGcm]::new($key, 16)
try {
  $aes.Decrypt($nonce, $ciphertext, $tag, $plaintext)
} finally {
  $aes.Dispose()
}

[IO.File]::WriteAllBytes((Join-Path (Get-Location) $OutputFile), $plaintext)
Write-Host "Decrypted package written to $OutputFile"
