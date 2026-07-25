# PC Remote Control Encrypted Package

This private repository stores the PC remote-control tool as an encrypted package only.

## Contents

- `pc-control-tool.tar.gz.aes256gcm` is encrypted with AES-256-GCM.
- `pc-control-tool.zip.sha256` is the checksum of the encrypted package.
- `decrypt-package.ps1` decrypts the package on a trusted Windows machine.

## Decrypt

```powershell
.\decrypt-package.ps1 -KeyFile "C:\path\to\pc-control-tool-key.txt"
tar -xzf .\pc-control-tool.tar.gz -C .\pc-control-tool
```

Keep the key file private. Anyone without the key cannot read the tool files from this repository.
