//
//  CreateUserView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.modelContext) private var modelContext // 获取数据上下文
    @Environment(\.dismiss) var dismiss  // 用来关闭当前视图
    @AppStorage("isUserRegistered") private var isUserRegistered: Bool = false


    var body: some View {
        VStack {
            // 头像区域
            HStack {
                if let image = viewModel.randomImage {
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
                Button(action: viewModel.generateRandomImage) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top)

            // 显示地址
            HStack {
                Text("Address: \(viewModel.address ?? "building...")")
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                // 拷贝地址按钮
                Button(action: viewModel.copyAddressToClipboard) {
                    Image(systemName: viewModel.isCopiedAddress ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
            }
            .onAppear {
                // 当视图出现时，自动使 TextEditor 获取焦点
                viewModel.setModelContext(modelContext: modelContext)
            }
            .padding(.horizontal)

            // 显示私钥
            HStack {
                Text("Private Key: \(viewModel.isPrivateKeyVisible ? viewModel.privateKey ?? "building..." : String(repeating: "*", count: viewModel.privateKey?.count ?? 0))")
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                // 眼睛图标，切换私钥的可见性
                Button(action: { viewModel.isPrivateKeyVisible.toggle() }) {
                    Image(systemName: viewModel.isPrivateKeyVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
                
                // 拷贝私钥按钮
                Button(action: viewModel.copyPrivateKeyToClipboard) {
                    Image(systemName: viewModel.isCopiedPrivateKey ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .padding(.leading)
                }
            }
            .padding()
            
            // 动态增加键值对输入框
            VStack {
                ForEach(0..<viewModel.keyValuePairs.count, id: \.self) { index in
                    HStack {
                        TextField("Key", text: $viewModel.keyValuePairs[index].key)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Value", text: $viewModel.keyValuePairs[index].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            
            // 加号按钮，添加新的键值对输入框
            Button(action: viewModel.addKeyValuePair) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            
            Spacer()
            // 显示错误信息
            ForEach(viewModel.errorMessages, id: \.self) { message in
                Text(message)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
            // 创建用户按钮
            Button("Create User") {
                viewModel.createUser()
            }
            .onChange(of: viewModel.isUserCreated) {_, isCreated in
                if isCreated {
                    // 用户创建成功，跳转到首页
                    // 这里使用一个简单的 dismiss 来模拟跳转到首页
                    // 设置注册状态为已注册
                    isUserRegistered = true
                    dismiss()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            viewModel.generateRandomImage()
            viewModel.generatePrivateKeyAndAddress()
        }
        .padding()
    }
}
