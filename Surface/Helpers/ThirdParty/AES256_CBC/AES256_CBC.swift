//
//  AESHelper.swift
//  wyndu
//
//  Created by Saurabh Shukla on 7/22/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
//Replace following values of 'AES_KEY' and 'AES_IV' with your own values of key and iv.

//////////*********************************************//////////////////////
let AES_KEY = "siht si ym terces yek oi nfhrtdx"
let AES_IV = "abcdefghijklmnop"
//////////*********************************************//////////////////////

//MARK: AES encryption/decryption properties for String datatype
extension String {
    
    ///Returns an 'AES 256 CBC' encoded string
    var aesEncrypt:String? {
        
        let options = kCCOptionPKCS7Padding
        if let keyData = AES_KEY.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let base64cryptStringOut = keyData.withUnsafeBytes {(keyBytes: UnsafePointer<CChar>)->String? in
                return data.withUnsafeBytes {(dataBytes: UnsafePointer<CChar>)->String? in
                    
                    let cryptStatus = CCCrypt(operation,
                                              algoritm,
                                              options,
                                              keyBytes, keyLength,
                                              AES_IV,
                                              dataBytes, data.count,
                                              cryptData.mutableBytes, cryptData.length,
                                              &numBytesEncrypted)
                    
                    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                        
                        cryptData.length = Int(numBytesEncrypted)
                        let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                        return base64cryptString
                    }
                    return nil
                }
            }
            return base64cryptStringOut
        }
        return nil
    }
    
    ///Decodes an 'AES 256 CBC' encoded string
    var aesDecrypt:Any? {
        
        let options = kCCOptionPKCS7Padding
        if let keyData = AES_KEY.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let unencryptedMessageOut = keyData.withUnsafeBytes {(keyBytes: UnsafePointer<CChar>)->Any? in
                let cryptStatus = CCCrypt(operation,
                                          algoritm,
                                          options,
                                          keyBytes, keyLength,
                                          AES_IV,
                                          data.bytes, data.length,
                                          cryptData.mutableBytes, cryptData.length,
                                          &numBytesEncrypted)
                
                if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                    
                    cryptData.length = Int(numBytesEncrypted)
                    let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                    
                    //check if decrypted string is a json, return the json
                    do {
                        return try JSONSerialization.jsonObject(with: cryptData as Data, options: [])
                    } catch {
                        //print(error.localizedDescription)
                    }
                    
                    //check if decrypted string is a base64Encoded data, return the data
                    if let unencrypted = unencryptedMessage, let data = Data(base64Encoded:unencrypted){
                        return data
                    }
                    //if decrypted string is simply a string, return the string
                    return unencryptedMessage
                }
                return nil
            }
            return unencryptedMessageOut
        }
        return nil
    }
}

//MARK: AES encryption/decryption properties for Data datatype
extension Data {
    
    var aesEncrypt:String?{
        return String(data: self, encoding: String.Encoding.utf8)?.aesEncrypt
    }
    var aesDecrypt:Any?{
        return String(data: self, encoding: String.Encoding.utf8)?.aesDecrypt
    }
}

//MARK: AES encryption property for Dictionary datatype
extension Dictionary {
    
    var aesEncrypt:String?{
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData.aesEncrypt
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

//MARK: AES encryption property for Array datatype
extension Array {
    
    var aesEncrypt:String?{
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData.aesEncrypt
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

//MARK: AES encryption property for UIImage datatype
extension UIImage{
    
    var aesEncrypt:String?{
        let data = UIImagePNGRepresentation(self)
        return data?.base64EncodedString().aesEncrypt
    }
}
