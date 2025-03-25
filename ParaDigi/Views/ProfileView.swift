//
//  ProfileView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct ProfileView: View {
    @State private var isAirplaneModeOn = false // 示例开关状态
    @State private var isNotificationsOn = true // 示例开关状态
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = PostFeedViewModel()
    
    @AppStorage("isUserRegistered") private var isUserRegistered: Bool = false

    
    var body: some View {
        NavigationStack {
            List {
                // 个人信息部分
                Section {
                    NavigationLink(destination: Text("Hello")) {
                        HStack {
                            if let b64 = viewModel.fetchDefaultUserInfo(modelContext: modelContext)?["avatar"]?.displayText {
                                if let imageData = Data(base64Encoded: b64) {
                                    if let uiImage = UIImage(data: imageData) {
                                        // 显示图片
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                            .shadow(radius: 3)
                                    }
                                }
                            }else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }
                            
                            
                            
                            VStack(alignment: .leading) {
                                if let nickname = viewModel.fetchDefaultUserInfo(modelContext: modelContext)?["nickname"]?.displayText {
                                    Text(nickname)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                } else {
                                    Text("Anonymouse")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                Text("ParaDigi ID, Last Signature & Nonce") // 媒体与购买 -> Media & Purchases
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // 第一组设置：通用功能
                Section {
                    // 飞行模式（带开关）
                    Toggle(isOn: $isAirplaneModeOn) {
                        HStack {
                            Image(systemName: "airplane")
                                .foregroundColor(.orange)
                            Text("Airplane Mode") // 飞行模式 -> Airplane Mode
                        }
                    }
                    
                    // Wi-Fi（带箭头和描述）
                    NavigationLink {
                        Text("Wi-Fi Settings Page") // Wi-Fi 设置页面 -> Wi-Fi Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.blue)
                            Text("Wi-Fi")
                            Spacer()
                            Text("Not Connected") // 未连接 -> Not Connected
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 静音（带箭头）
                    NavigationLink {
                        Text("Mute Settings Page") // 静音设置页面 -> Mute Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "microphone.slash.fill")
                                .foregroundColor(.cyan)
                            Text("Mute") // 静音 -> Mute
                            Spacer()
                            Text("Off") // 已关闭 -> Off
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // 第二组设置：通知与声音
                Section {
                    // 通知（带开关）
                    Toggle(isOn: $isNotificationsOn) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.red)
                            Text("Notifications") // 通知 -> Notifications
                        }
                    }
                    
                    // 声音与触感（带箭头）
                    NavigationLink {
                        Text("Sounds & Haptics Settings Page") // 声音与触感设置页面 -> Sounds & Haptics Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.green)
                            Text("Sounds & Haptics") // 声音与触感 -> Sounds & Haptics
                        }
                    }
                }
                
                
                // 第四组设置：其他
                Section {
                    // 关于本机（纯文本）
                    NavigationLink {
                        Text("About Page") // 关于本机页面 -> About Page
                    } label: {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.gray)
                            Text("About") // 关于本机 -> About
                        }
                    }
                    
                    // 软件更新（带徽章）
                    NavigationLink {
                        Text("Software Update Page") // 软件更新页面 -> Software Update Page
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.purple)
                            Text("Software Update") // 软件更新 -> Software Update
                            Spacer()
                            // 示例徽章
                            Text("1")
                                .font(.caption)
                                .padding(4)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    
                }
                
                // 底部：退出登录按钮
                Section {
                    Button(action: {
                        // 在这里添加退出登录的逻辑
                        isUserRegistered = false
                    }) {
                        Text("Sign Out")
                            .font(.body)
                            .foregroundColor(.red) // 红色文字，模仿 iOS 退出登录样式
                            .frame(maxWidth: .infinity) // 让文字居中
                    }
                }

            }
            .listStyle(.insetGrouped) // 模仿设置应用的列表样式
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.setModelContext(modelContext: modelContext)
            }
        }
    }
}


