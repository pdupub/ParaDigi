//
//  CreateUserView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//

import SwiftUI
import UIKit

// 假设 CompatibleCrypto.swift 中提供的方法
//import CompatibleCrypto

struct SignUpView: View {
    @State private var randomImage: UIImage?
    @State private var base64ImageString: String?
    @State private var privateKey: String?
    @State private var address: String?
    @State private var isPrivateKeyVisible = false
    @State private var nickname: String = ""
    @State private var keyValuePairs: [(key: String, value: String)] = [("", "")]
    
    @State private var isCopiedAddress = false
    @State private var isCopiedPrivateKey = false
    
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
                    Text("生成头像中...")
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
                Text("地址: \(address ?? "生成中...")")
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                // 拷贝地址按钮
                Button(action: copyAddressToClipboard) {
                    Image(systemName: isCopiedAddress ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
            }
            .padding()

            // 显示私钥
            HStack {
                Text(isPrivateKeyVisible ? privateKey ?? "生成中..." : String(repeating: "*", count: privateKey?.count ?? 0))
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

            // 昵称输入框
            TextField("请输入昵称", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    .padding(.vertical, 5)
                }
            }
            
            // 加号按钮，添加新的键值对输入框
            Button(action: addKeyValuePair) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top)
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
        randomImage = ImageUtilities.generateRandomBlockImage(size: CGSize(width: 200, height: 200), blocks: 10)
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
        // 在这里处理创建用户的逻辑
        print("用户创建成功")
        print("昵称：\(nickname)")
        print("私钥：\(privateKey ?? "无私钥")")
        print("地址：\(address ?? "无地址")")
    }
}

