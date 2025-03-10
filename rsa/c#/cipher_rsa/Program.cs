﻿using System;
using System.Security.Cryptography;

namespace RsaCryptoExample
{
    static class Program
    {
        static void Main()
        {
            //lets take a new CSP with a new 2048 bit rsa key pair
            var csp = new RSACryptoServiceProvider(2048);

            //how to get the private key
            var privKey = csp.ExportParameters(true);

            //and the public key ...
            var pubKey = csp.ExportParameters(false);

            //converting the public key into a string representation
            string pubKeyString;
            {
                //we need some buffer
                var sw = new System.IO.StringWriter();
                //we need a serializer
                var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
                //serialize the key into the stream
                xs.Serialize(sw, pubKey);
                //get the string from the stream
                pubKeyString = sw.ToString();
            }

            //converting it back
            {
                //get a stream from the string
                var sr = new System.IO.StringReader(pubKeyString);
                //we need a deserializer
                var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
                //get the object back from the stream
                pubKey = (RSAParameters)xs.Deserialize(sr);
            }

            //we have a public key ... let's get a new csp and load that key
            csp = new RSACryptoServiceProvider();
            csp.ImportParameters(pubKey);

            //we need some data to encrypt
            Console.WriteLine("Text to Encrypt?");
            var plainTextData = Console.ReadLine();

            if (!string.IsNullOrEmpty(plainTextData))
            {
                //for encryption, always handle bytes...
                var bytesPlainTextData = System.Text.Encoding.Unicode.GetBytes(plainTextData);

                //apply pkcs#1.5 padding and encrypt our data 
                var bytesCypherText = csp.Encrypt(bytesPlainTextData, false);

                //we might want a string representation of our cypher text... base64 will do
                var cypherText = Convert.ToBase64String(bytesCypherText);

                //first, get our bytes back from the base64 string ...
                bytesCypherText = Convert.FromBase64String(cypherText);

                //we want to decrypt, therefore we need a csp and load our private key
                csp = new RSACryptoServiceProvider();
                csp.ImportParameters(privKey);

                //decrypt and strip pkcs#1.5 padding
                var decryptedBytesPlainTextData = csp.Decrypt(bytesCypherText, false);

                //get our original plainText back...
                var decryptedPlainTextData = System.Text.Encoding.Unicode.GetString(decryptedBytesPlainTextData);

                Console.WriteLine("\nOriginal Text: " + plainTextData);
                Console.WriteLine("\nEncrypted Text: " + cypherText);
                Console.WriteLine("\nDecrypted Text: " + decryptedPlainTextData);
            }
            else
            {
                Console.WriteLine("Input was Empty or Null. Please try again!");
            }

            Console.WriteLine("Enter to exit...");
            Console.ReadLine();
        }
    }
}