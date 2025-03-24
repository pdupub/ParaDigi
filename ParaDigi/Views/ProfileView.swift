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
    @Environment(\.colorScheme) var colorScheme // 用于适配深色模式
    
    var body: some View {
        NavigationStack {
            List {
                // 个人信息部分
                Section {
                    HStack {
                        // 用户头像（示例）
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text("Peng Liu")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Apple ID, iCloud, Media & Purchases") // 媒体与购买 -> Media & Purchases
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
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
                    
                    // 蓝牙（带箭头）
                    NavigationLink {
                        Text("Bluetooth Settings Page") // 蓝牙设置页面 -> Bluetooth Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "bluetooth")
                                .foregroundColor(.blue)
                            Text("Bluetooth") // 蓝牙 -> Bluetooth
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
                
                // 第三组设置：显示与隐私
                Section {
                    // 显示与亮度（带箭头）
                    NavigationLink {
                        Text("Display & Brightness Settings Page") // 显示与亮度设置页面 -> Display & Brightness Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.yellow)
                            Text("Display & Brightness") // 显示与亮度 -> Display & Brightness
                        }
                    }
                    
                    // 隐私（带箭头）
                    NavigationLink {
                        Text("Privacy Settings Page") // 隐私设置页面 -> Privacy Settings Page
                    } label: {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.blue)
                            Text("Privacy") // 隐私 -> Privacy
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
            }
            .listStyle(.insetGrouped) // 模仿设置应用的列表样式
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ProfileView()
//                .preferredColorScheme(.light)
//                .previewDisplayName("Light Mode")
//            
//            ProfileView()
//                .preferredColorScheme(.dark)
//                .previewDisplayName("Dark Mode")
//        }
//    }
//}
