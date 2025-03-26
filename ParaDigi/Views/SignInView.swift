//
//  SignInView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/26.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("isUserRegistered") private var isUserRegistered: Bool = false
    @State var privkey: String = ""
    
    var body: some View {
        NavigationStack { // 用 NavigationStack 包裹内容以支持导航
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Private Key")
                        HStack {
                            
                            TextField("...", text: $privkey, onCommit: {})
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                viewModel.checkPrivateKey(privkey)
                            }) {
                                Image(systemName: "arrowtriangle.right.circle.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                            }
                            
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Address")
                        HStack {
                            Text(verbatim: "\(viewModel.address ?? "building...")")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: viewModel.copyAddressToClipboard) {
                                Image(systemName: viewModel.isCopiedAddress ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                            }
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.gray)
                        Text("Key & Address")
                        Spacer()
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        ZStack {
                            if let user = viewModel.loginUserInfo {
                                user.avatarImage
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
                        }
                        Spacer()
                    }
                    .padding()
                } header: {
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.gray)
                        Text("Avatar")
                        Spacer()
                    }
                }
                
                
                Section {
                    VStack {
                        let attrs = viewModel.loginUserAttrs()
                        ForEach(2..<attrs.count, id: \.self) { index in
                            if index % 2 == 0 {
                                HStack {
                                    Text("\(attrs[index])")
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                                    Spacer()
                                    Text("\(attrs[index+1])")
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)

                                }
                            }
                        }
                    }
                    
                } header: {
                    HStack {
                        Image(systemName: "info.square.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.gray)
                        Text("Information")
                        Spacer()
                    }
                }
                
                
                
                Section {
                    Button(action: {
                        viewModel.signin()
                    }) {
                        Text("Unlock Current Key")
                            .font(.body)
                            .bold()
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .onChange(of: viewModel.isUserUnlocked) { _, isUnlocked in
                        if isUnlocked {
                            isUserRegistered = true
                            dismiss()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // 添加右上角的 Sign in
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }.frame(height:16)
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext: modelContext)
            }
        }
        .navigationBarBackButtonHidden(true) // 隐藏返回箭头
    }
}
