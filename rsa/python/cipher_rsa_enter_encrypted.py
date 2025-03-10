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
    message = input("Already Encrypt Text?")

# the encrypted message can be decrypted
# with ras.decrypt method and private key
# decrypt method returns encoded byte string,
# use decode method to convert it to string
# public key cannot be used for decryption
decMessage = rsa.decrypt(message, privateKey).decode()

print("decrypted string: ", decMessage)