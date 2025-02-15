//
//  CreateUserView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//

import SwiftUI


struct SignUpView: View {
    @State private var randomImage: UIImage?
    @State private var base64ImageString: String?
    @State private var privateKey: String?
    @State private var address: String?
    @State private var isPrivateKeyVisible = false
    @State private var nickname: String = ""
    @State private var keyValuePairs: [(key: String, value: String)] = [("Nickname",""),("", "")]
    
    @State private var isCopiedAddress = false
    @State private var isCopiedPrivateKey = false
    @State private var errorMessages: [String] = []
    var body: some View {
        VStack {
            // 头像区域
            HStack {
                if let image = randomImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } else {
                    Text("Avatar building...")
                }
                
                // 右侧按钮，重新生成头像
                Button(action: generateRandomImage) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top)

            // 显示地址
            HStack {
                Text("Address: \(address ?? "building...")")
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                // 拷贝地址按钮
                Button(action: copyAddressToClipboard) {
                    Image(systemName: isCopiedAddress ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
            }
            .padding(.horizontal)

            // 显示私钥
            HStack {
                Text("Private Key: \(isPrivateKeyVisible ? privateKey ?? "building..." : String(repeating: "*", count: privateKey?.count ?? 0))")
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                // 眼睛图标，切换私钥的可见性
                Button(action: { isPrivateKeyVisible.toggle() }) {
                    Image(systemName: isPrivateKeyVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
                
                // 拷贝私钥按钮
                Button(action: copyPrivateKeyToClipboard) {
                    Image(systemName: isCopiedPrivateKey ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
            }
            .padding()
            
            
   
            // 动态增加键值对输入框
            VStack {
                ForEach(0..<keyValuePairs.count, id: \.self) { index in
                    HStack {
                        TextField("Key", text: $keyValuePairs[index].key)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Value", text: $keyValuePairs[index].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
//                    .padding()
                }
            }
            
            // 加号按钮，添加新的键值对输入框
            Button(action: addKeyValuePair) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            
            Spacer()
            // 显示错误信息
            ForEach(errorMessages, id: \.self) { message in
                Text(message)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
            // 创建用户按钮
            Button("Create User") {
                createUser()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            generateRandomImage()
            generatePrivateKeyAndAddress()
        }
        .padding()
    }
    
    // 生成随机头像
    private func generateRandomImage() {
        randomImage = ImageUtilities.generateRandomAvatarImage()
        base64ImageString = ImageUtilities.imageToBase64(image: randomImage!)
    }
    
    // 使用 CompatibleCrypto.swift 生成私钥和地址
    private func generatePrivateKeyAndAddress() {
        let privateKeyData = CompatibleCrypto.generatePrivateKey()
        privateKey = privateKeyData.map { String(format: "%02x", $0) }.joined()
        
        let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
//        var publicKey = publicKeyData.map { String(format: "%02x", $0) }.joined()

        address = CompatibleCrypto.generateAddress(publicKey: publicKeyData)
    }

    // 拷贝地址到剪贴板
    private func copyAddressToClipboard() {
        if let address = address {
            UIPasteboard.general.string = address
            isCopiedAddress = true
        }
    }
    
    // 拷贝私钥到剪贴板
    private func copyPrivateKeyToClipboard() {
        if let privateKey = privateKey {
            UIPasteboard.general.string = privateKey
            isCopiedPrivateKey = true
        }
    }
    
    // 添加新的键值对输入框
    private func addKeyValuePair() {
        keyValuePairs.append(("", ""))
    }
    
    // 创建用户的业务逻辑
    private func createUser() {
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
                QContent(data: AnyCodable("avatar"), format: "str"), // Key
                QContent(data: AnyCodable(base64ImageString!), format: "base64") // Value
            ]
            for index in (0..<keyValuePairs.count) {
                let (key, value) = keyValuePairs[index]
                contents.append(QContent(data: AnyCodable(key), format: "str")) // Key
                contents.append(QContent(data: AnyCodable(value), format: "str")) // Key
            }
            
            let last = ""
            let nonce = 1
            let references: [String] = []
            let type: Int = 1

            // 创建 UnsignedQuantum 对象
            let unsignedQuantum = UnsignedQuantum(contents: contents, last: last, nonce: nonce, references: references, type: type)
//            let jsonString = unsignedQuantum.toJsonString()
//            print(jsonString)
            
            if let jsonData = try? JSONEncoder().encode(unsignedQuantum) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Encoded JSON: \(jsonString)")
                }
            }
        }

    }
}

