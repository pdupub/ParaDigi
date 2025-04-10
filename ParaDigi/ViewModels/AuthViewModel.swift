//
//  SignUpViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/16.
//

import SwiftUI
import SwiftData

class AuthViewModel: ObservableObject {
    @Published var randomImage: UIImage?
    @Published var base64ImageString: String?
    @Published var privateKey: String?
    @Published var address: String?
    @Published var keyValuePairs: [(key: String, value: String)] = [("nickname", ""),("", "")]
    @Published var errorMessages: [String] = []
    
    @Published var isCopiedAddress = false
    @Published var isCopiedPrivateKey = false
    
    @Published var isUserCreated: Bool = false
    @Published var isUserUnlocked: Bool = false
    
    @Published var loginUserInfo: StdUser?
    
    private var modelContext: ModelContext? // 直接持有 modelContext
    
    
    
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    // 生成随机头像
    func generateRandomImage() {
        randomImage = ImageUtilities.generateRandomAvatarImage()
        base64ImageString = ImageUtilities.imageToBase64(image: randomImage!)
    }
    
    // 使用 CompatibleCrypto.swift 生成私钥和地址
    func generatePrivateKeyAndAddress() {
        let privateKeyData = CompatibleCrypto.generatePrivateKey()
        privateKey = privateKeyData.map { String(format: "%02x", $0) }.joined()

        let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        address = CompatibleCrypto.generateAddress(publicKey: publicKeyData!)
    }

    // 拷贝地址到剪贴板
    func copyAddressToClipboard() {
        if let address = address {
            UIPasteboard.general.string = address
            isCopiedAddress = true
        }
    }

    // 拷贝私钥到剪贴板
    func copyPrivateKeyToClipboard() {
        if let privateKey = privateKey {
            UIPasteboard.general.string = privateKey
            isCopiedPrivateKey = true
        }
    }

    // 添加新的键值对输入框
    func addKeyValuePair() {
        keyValuePairs.append(("", ""))
    }
    
    func loginUserAttrs() -> [String]{
        var attrs:[String] = []
        if let user = loginUserInfo {
            if !user.extra.isEmpty {
                for (key, value) in user.extra {
                    attrs.append(key)
                    attrs.append(value.displayText)
                }
            }
        }
        return attrs
    }
    
    func checkPrivateKey(_ privKey: String) {
     
        guard let privateKeyData = CompatibleCrypto.generatePrivateKey(fromString: privKey) else {return}

        
        let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        address = CompatibleCrypto.generateAddress(publicKey: publicKeyData!)
        
        guard let addr = address else {return }
        privateKey = privKey
        loginUserInfo = QuantumManager.getUser(signer:addr, modelContext: modelContext)

    }

    func signin() {
        // 保存private key
        guard let privateKeyData = CompatibleCrypto.generatePrivateKey(fromString: privateKey!) else { return }
        
        guard let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData) else { return }
        
        let address = CompatibleCrypto.generateAddress(publicKey: publicKeyData)
        
        let kk = "ParaDigiAddr:\(address)"
        _ = KeychainHelper.delete(key: kk)
        _ = KeychainHelper.delete(key: Constants.defaultPrivateKey)
        
        if !KeychainHelper.save(key: kk, data: privateKeyData ) { return }
        
        if !KeychainHelper.save(key: Constants.defaultPrivateKey, data: privateKeyData) { return }
        isUserUnlocked = true
    }
    
    // 创建用户的业务逻辑
    func createUser() {
        errorMessages.removeAll()  // 清空之前的错误信息

        for index in (0..<keyValuePairs.count).reversed() {  // 使用 reversed 遍历，以防删除时出错
            let (key, value) = keyValuePairs[index]
            
            // 如果 key 和 value 都为空，删除该行
            if key.isEmpty && value.isEmpty {
                keyValuePairs.remove(at: index)
            } else {
                // 如果只填写了 key 或 value，提示用户填写另一框
                if key.isEmpty || value.isEmpty {
                    let missingField = key.isEmpty ? "key" : "value"
                    errorMessages.append("Please complete the \(missingField) (Line \(index + 1))")
                }
            }
        }
        errorMessages.reverse()

        if errorMessages.isEmpty {
            // 保存private key
            guard let privateKeyData = CompatibleCrypto.generatePrivateKey(fromString: privateKey!) else { return }
            
            guard let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData) else { return }
            
            let address = CompatibleCrypto.generateAddress(publicKey: publicKeyData)
            
            if !KeychainHelper.save(key: "ParaDigiAddr:\(address)", data: privateKeyData ) { return }
            
            if !KeychainHelper.save(key: Constants.defaultPrivateKey, data: privateKeyData) { return }
            
            
            // 组装contents
            var contents:[QContent] = [
                QContent(order:0, data: AnyCodable("avatar"), format: "key"), // Key
                QContent(order:1, data: AnyCodable(base64ImageString!), format: "base64") // Value
            ]
            for index in (0..<keyValuePairs.count) {
                let (key, value) = keyValuePairs[index]
                contents.append(QContent(order:index*2 + 2, data: AnyCodable(key), format: "key")) // Key
                contents.append(QContent(order:index*2 + 3, data: AnyCodable(value), format: "str")) // Value
            }
            
            guard let signedQuantum = QuantumManager.createSignedQuantum(contents, qtype: Constants.quantumTypeIntegration, modelContext: modelContext) else {
                print("create signedQuantum fail")
                return
            }
            
            QuantumManager.saveQuantumToLocal(signedQuantum, modelContext: modelContext)
            print("save quantum to local success")
            
            isUserCreated = true
        }
    }
}
