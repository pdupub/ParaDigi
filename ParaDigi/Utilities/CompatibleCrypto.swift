//
//  CompatibleCrypto.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/20.
//

import Foundation
import CryptoKit

struct CompatibleCrypto {
    // 生成随机私钥
    static func generatePrivateKey() -> Data {
        var key = Data(count: 32) // 私钥长度为 32 字节
        let result = key.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        assert(result == errSecSuccess, "Failed to generate secure random bytes")
        return key
    }
    
    // 从私钥生成公钥（非压缩格式）
    static func generatePublicKey(privateKey: Data) -> Data {
        let privateKeyKey = try! P256.Signing.PrivateKey(rawRepresentation: privateKey)
        let publicKey = privateKeyKey.publicKey.rawRepresentation
        return publicKey
    }

    // 从公钥生成地址
    static func generateAddress(publicKey: Data) -> String {
        let hash = SHA256.hash(data: publicKey)
        let addressData = Data(hash.suffix(20)) // 取后 20 字节
        return "0x" + addressData.map { String(format: "%02x", $0) }.joined()
    }

    // 使用私钥签名消息
    static func signMessage(privateKey: Data, message: Data) -> Data {
        let privateKeyKey = try! P256.Signing.PrivateKey(rawRepresentation: privateKey)
        let signature = try! privateKeyKey.signature(for: message)
        return signature.derRepresentation
    }

    // 验证签名
    static func verifySignature(message: Data, signature: Data, publicKey: Data) -> Bool {
        guard let publicKeyKey = try? P256.Signing.PublicKey(rawRepresentation: publicKey),
              let ecdsaSignature = try? P256.Signing.ECDSASignature(derRepresentation: signature) else {
            return false
        }
        return publicKeyKey.isValidSignature(ecdsaSignature, for: message)
    }
    
    // 从字符串生成私钥
    static func generatePrivateKey(fromString string: String) -> Data? {
        // 将字符串转换为 Data
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        // 确保字符串长度为 32 字节，不足的部分用 0 填充
        var privateKey = data
        if privateKey.count < 32 {
            privateKey.append(contentsOf: [UInt8](repeating: 0, count: 32 - privateKey.count))
        } else if privateKey.count > 32 {
            privateKey = privateKey.prefix(32)
        }
        
        return privateKey
    }
}
