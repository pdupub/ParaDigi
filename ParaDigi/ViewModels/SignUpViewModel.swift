//
//  SignUpViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/16.
//

import SwiftUI
import SwiftData

class SignUpViewModel: ObservableObject {
    @Published var randomImage: UIImage?
    @Published var base64ImageString: String?
    @Published var privateKey: String?
    @Published var address: String?
    @Published var keyValuePairs: [(key: String, value: String)] = [("nickname", ""),("", "")]
    @Published var errorMessages: [String] = []
    
    @Published var isPrivateKeyVisible = false
    @Published var isCopiedAddress = false
    @Published var isCopiedPrivateKey = false
    
    private var modelContext: ModelContext? // 直接持有 modelContext
    private var quantumManager: QuantumManager

    init() {
        self.quantumManager = QuantumManager()
    }
    
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
        address = CompatibleCrypto.generateAddress(publicKey: publicKeyData)
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
            var contents:[QContent] = [
                QContent(data: AnyCodable("avatar"), format: "key"), // Key
                QContent(data: AnyCodable(base64ImageString!), format: "base64") // Value
            ]
            for index in (0..<keyValuePairs.count) {
                let (key, value) = keyValuePairs[index]
                contents.append(QContent(data: AnyCodable(key), format: "key")) // Key
                contents.append(QContent(data: AnyCodable(value), format: "str")) // Value
            }
            
            let last = ""
            let nonce = 1
            let references: [String] = []
            let type: Int = 1

            // 创建 UnsignedQuantum 对象
            let unsignedQuantum = UnsignedQuantum(contents: contents, last: last, nonce: nonce, references: references, type: type)
            if let jsonData = try? JSONEncoder().encode(unsignedQuantum) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    guard let privateKeyData = CompatibleCrypto.generatePrivateKey(fromString: privateKey!) else { return }
                    let signatureData = CompatibleCrypto.signMessage(privateKey: privateKeyData, message: jsonData)
                    let signature = signatureData.map { String(format: "%02x", $0) }.joined()
                    let signedQuantum = SignedQuantum(unsignedQuantum: unsignedQuantum, signature: signature, signer: address)
                    
                    if let signedData = try? JSONEncoder().encode(signedQuantum) {
                        if let signedString = String(data:signedData, encoding: .utf8) {
                            print("Encoded JSON: \(signedString)")
                        }
                    }

                    let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
                    
                    let isVerify = CompatibleCrypto.verifySignature(message: jsonData, signature: signatureData, publicKey: publicKeyData)
                    print("Verify Signature: \(isVerify)")
                    
                    self.quantumManager.publishQuantum(signedQuantum, modelContext: modelContext)
                }
            }
        }
    }
}
