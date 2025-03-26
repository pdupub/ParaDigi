//
//  CreateUserView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//
import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("isUserRegistered") private var isUserRegistered: Bool = false

    var body: some View {
        NavigationStack { // 用 NavigationStack 包裹内容以支持导航
            List {
                Section {
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
                            
                            Button(action: viewModel.generateRandomImage) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                            .offset(x: 70, y: 40)
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
                    VStack(alignment: .leading) {
                        Text("Private Key")
                        HStack {
                            Text("\(viewModel.privateKey ?? "building...")")
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: viewModel.copyPrivateKeyToClipboard) {
                                Image(systemName: viewModel.isCopiedPrivateKey ? "checkmark.circle.fill" : "doc.on.clipboard.fill")
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
                        Text("Address & Key")
                        Spacer()
                    }
                }
                
                Section {
                    VStack {
                        ForEach(0..<viewModel.keyValuePairs.count, id: \.self) { index in
                            HStack {
                                TextField("Key", text: $viewModel.keyValuePairs[index].key)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Value", text: $viewModel.keyValuePairs[index].value)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        Button(action: viewModel.addKeyValuePair) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    ForEach(viewModel.errorMessages, id: \.self) { message in
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.top, 5)
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
                        viewModel.createUser()
                    }) {
                        Text("Create New ID")
                            .font(.body)
                            .bold()
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .onChange(of: viewModel.isUserCreated) { _, isCreated in
                        if isCreated {
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
                    NavigationLink(destination: SignInView()) {
                        Text("Sign in")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    .frame(height:16)
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext: modelContext)
                viewModel.generateRandomImage()
                viewModel.generatePrivateKeyAndAddress()
            }
        }
        .navigationBarBackButtonHidden(true) // 隐藏返回箭头
    }
}


