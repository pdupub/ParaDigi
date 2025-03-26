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
        List {

            
            Section {
                
                // 头像区域
                HStack {
                    Spacer()
                    ZStack {
                        if let image = viewModel.randomImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        }
                        
                        // 右侧按钮，重新生成头像
                        Button(action: viewModel.generateRandomImage) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .offset(x:70, y:40)
                    }
                    Spacer()
                }
                .padding()
            } header: {
                HStack{
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.gray)
                    Text("Avatar")
                    Spacer()
                }
            }
            
            Section {
                // 显示地址
                VStack(alignment: .leading) {
                    Text("Address")
                    HStack {
                        Text(verbatim: "\(viewModel.address ?? "building...")")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .lineLimit(nil) // 允许换行
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading) // 保证尽量在第一行完整显示
                            
                        // 拷贝地址按钮
                        Button(action: viewModel.copyAddressToClipboard) {
                            Image(systemName: viewModel.isCopiedAddress ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                                .padding(.leading)
                        }
                    }
                }
                // 显示私钥
                VStack(alignment: .leading) {
                    Text("Private Key")
                    HStack {
       
                        Text("\(viewModel.privateKey ?? "building...")")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .lineLimit(nil) // 允许换行
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading) // 保证尽量在第一行完整显示
                        
                                                    
                        // 拷贝私钥按钮
                        Button(action: viewModel.copyPrivateKeyToClipboard) {
                            Image(systemName: viewModel.isCopiedPrivateKey ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                                .padding(.leading)
                        }
                        
                    }
                }
                
            }  header: {
                HStack{
                    Image(systemName: "person.badge.key.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.gray)
                    Text("Address & Key")
                    Spacer()
                }
            }
            
            Section {
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
                    // 加号按钮，添加新的键值对输入框
                    Button(action: viewModel.addKeyValuePair) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                

                
                // 显示错误信息
                ForEach(viewModel.errorMessages, id: \.self) { message in
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                
                
            } header: {
                HStack{
                    Image(systemName: "info.square.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.gray)
                    Text("Information")
                    Spacer()
                }
            }

            
            // 创建用户按钮
            Section {
                Button(action: {
                    viewModel.createUser()
                }) {
                    Text("Create New ID")
                        .font(.body)
                        .bold()
                        .foregroundColor(.red) // 红色文字，模仿 iOS 退出登录样式
                        .frame(maxWidth: .infinity) // 让文字居中
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
            }
                    
        }
        .listStyle(.insetGrouped) // 模仿设置应用的列表样式
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setModelContext(modelContext: modelContext)
            viewModel.generateRandomImage()
            viewModel.generatePrivateKeyAndAddress()
        }
    }
}
