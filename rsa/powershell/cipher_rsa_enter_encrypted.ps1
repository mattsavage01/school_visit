if (!(Test-Path -Path 'rsa.pub'))
{
    # Generate an RSA key pair
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $publicKey = $rsa.ToXmlString($false) # false for public key only
    $privateKey = $rsa.ToXmlString($true)  # true for both public and private keys

    $publicKey | Out-File "rsa.pub"
    $privateKey | Out-File "rsa.key"
}
else {
    #$publicKey = Get-Content 'rsa.pub'
    $privateKey = Get-Content 'rsa.key'
}

# Data to encrypt
$data = $($args[0])
if ($null -eq $data)
{
    Write-Host "Already Encrypt Text?"
    $data = Read-Host
}
$encoding = [System.Text.Encoding]::UTF8

# Decrypt the data using the private key
$rsaDecrypt = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsaDecrypt.FromXmlString($privateKey)
$encryptedBytes = [Convert]::FromBase64String($data)
$decryptedBytes = $rsaDecrypt.Decrypt($encryptedBytes, $false) # false for PKCS1 padding
$decryptedText = $encoding.GetString($decryptedBytes)

# Output
Write-Host "Original Text: $data"
Write-Host "Decrypted Text: $decryptedText"

# Clean up resources
$rsa.Dispose()
$rsaDecrypt.Dispose()