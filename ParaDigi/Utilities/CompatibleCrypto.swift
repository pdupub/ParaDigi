//
//  CompatibleCrypto.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/20.
//

import secp256k1
import Foundation
//import CryptoKit

struct CompatibleCrypto {
    // 生成随机私钥
    static func generatePrivateKey() -> Data {
//        var key = Data(count: 32) // 私钥长度为 32 字节
//        let result = key.withUnsafeMutableBytes {
//            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
//        }
//        assert(result == errSecSuccess, "Failed to generate secure random bytes")
//        return key
        
        return try! secp256k1.Recovery.PrivateKey().dataRepresentation
    }
    
    // 从 secp256k1 私钥生成公钥
    // 返回压缩格式（33 字节），需要生成以太坊地址时，则需要转换为未压缩格式
    static func generatePublicKey(privateKey: Data) -> Data? {
        guard let privKey = try? secp256k1.Recovery.PrivateKey(dataRepresentation: privateKey) else {
            return nil
        }
        return privKey.publicKey.dataRepresentation
    }
    
    // 从公钥生成地址
    static func generateAddress(publicKey: Data) -> String {
        let hash = SHA256.hash(data: publicKey)
        let addressData = Data(hash.suffix(20)) // 取后 20 字节
        return "0x" + addressData.map { String(format: "%02x", $0) }.joined()
    }
    
    
    // 使用私钥签名消息
    static func signMessage(privateKey: Data, message: Data) -> Data? {
        guard let privKey = try? secp256k1.Recovery.PrivateKey(dataRepresentation: privateKey) else {
            return nil
        }
        guard let signature = try? privKey.signature(for: message) else {
            return nil
        }
        return signature.dataRepresentation
    }
        
    
    // 验证签名
    static func verifySignature(message: Data, signature: Data, address: String) -> Bool {
        guard let publicKey = recovery(message: message, signature: signature) else { return false }
        let recovAddress = generateAddress(publicKey: publicKey)
        return recovAddress == address
    }
    
    
    static func recovery(message: Data, signature: Data) -> Data? {
        guard let signature = try? secp256k1.Recovery.ECDSASignature(dataRepresentation: signature) else { return nil }
        guard let publicKey = try? secp256k1.Recovery.PublicKey(message, signature: signature) else {return nil}
        return publicKey.dataRepresentation
    }
    
    // 从字符串生成私钥
    static func generatePrivateKey(fromString string: String) -> Data? {
        
        let privateBytes = try! string.bytes
        let privateKey = try! secp256k1.Recovery.PrivateKey(dataRepresentation: privateBytes)
        return privateKey.dataRepresentation
    }
}
