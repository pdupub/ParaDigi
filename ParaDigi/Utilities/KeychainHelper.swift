//
//  KeychainHelper.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/15.
//

import Foundation
import Security

class KeychainHelper {
    // 存储数据到 Keychain
    class func save(key: String, data: Data) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        // 删除旧的项，确保每次保存时不会重复添加
        SecItemDelete(query as CFDictionary)
        
        // 添加新的项
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    // 从 Keychain 中读取数据
    class func load(key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            return item as? Data
        } else {
            return nil
        }
    }
    
    // 删除 Keychain 中的数据
    class func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        return status == errSecSuccess
    }
}
