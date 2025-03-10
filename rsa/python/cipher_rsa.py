import rsa
import sys

# generate public and private keys with 
# rsa.newkeys method,this method accepts 
# key length as its parameter
# key length should be atleast 16
publicKey, privateKey = rsa.newkeys(1024)

# this is the string that we will be encrypting
message = sys.argv[1] if len(sys.argv) < 1 else ""
if message == "":
    message = input("Text to Encrypt?")

# rsa.encrypt method is used to encrypt 
# string with public key string should be 
# encode to byte string before encryption 
# with encode method
encMessage = rsa.encrypt(message.encode(), 
                         publicKey)

print("original string: ", message)
print("encrypted string: ", encMessage)

# the encrypted message can be decrypted 
# with rsa.decrypt method and private key
# decrypt method returns encoded byte string,
# use decode method to convert it to string
# public key cannot be used for decryption
decMessage = rsa.decrypt(encMessage, privateKey).decode()

print("decrypted string: ", decMessage)
