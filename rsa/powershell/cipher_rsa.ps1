# Generate an RSA key pair
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$publicKey = $rsa.ToXmlString($false) # false for public key only
$privateKey = $rsa.ToXmlString($true)  # true for both public and private keys

# Data to encrypt
$data = $($args[0])
if ($null -eq $data)
{
    Write-Host "Text to Encrypt?"
    $data = Read-Host
}
$encoding = [System.Text.Encoding]::UTF8
$bytes = $encoding.GetBytes($data)

# Encrypt the data using the public key
$rsaEncrypt = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsaEncrypt.FromXmlString($publicKey)
$encryptedBytes = $rsaEncrypt.Encrypt($bytes, $false) # false for PKCS1 padding
$encryptedText = [Convert]::ToBase64String($encryptedBytes)

# Decrypt the data using the private key
$rsaDecrypt = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsaDecrypt.FromXmlString($privateKey)
$decryptedBytes = $rsaDecrypt.Decrypt($encryptedBytes, $false) # false for PKCS1 padding
$decryptedText = $encoding.GetString($decryptedBytes)

# Output
Write-Host "Original Text: $data"
Write-Host "Encrypted Text: $encryptedText"
Write-Host "Decrypted Text: $decryptedText"

# Clean up resources
$rsa.Dispose()
$rsaEncrypt.Dispose()
$rsaDecrypt.Dispose()