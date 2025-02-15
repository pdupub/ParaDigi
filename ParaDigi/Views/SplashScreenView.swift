//
//  SplashScreenView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/14.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var showRegisterScreen = false

    var body: some View {
        Group {
            if isActive {
                if showRegisterScreen {
                    SignUpView()
                } else {
                    MainView() // 主界面视图
                }
            } else {
                ZStack {
                    Color.blue
                        .edgesIgnoringSafeArea(.all) // 背景色

                    VStack {
//                        Image(systemName: "app.fill") // 可以替换为自定义 logo
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.white)
//                            .padding()
                        
                        Text("ParaDigi")
                            .font(.system(size: 64, weight: .black))
                            .foregroundStyle(.white)
                        
                        Text("Welcome to Our World")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        checkPrivateKeyInKeychain()
                    }
                }
                .onAppear {
                    // 延迟 3 秒后跳转到主界面
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            checkPrivateKeyInKeychain()
                        }
                    }
                }
            }
        }
    }
    
    // 检查Keychain中是否存在私钥
    private func checkPrivateKeyInKeychain() {
        if let _ = KeychainHelper.load(key: "userPrivateKey") {
            // 如果Keychain中存在私钥，跳转到主页面
            showRegisterScreen = false
        } else {
            // 如果Keychain中不存在私钥，跳转到注册页面
            showRegisterScreen = true
        }
        
        isActive = true
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

