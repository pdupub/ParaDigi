//
//  SplashScreenView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/14.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("isUserRegistered") private var isUserRegistered: Bool = false  // 判断是否注册
    @State private var isActive = false
    @State private var showRegisterScreen = false

    var body: some View {
        Group {
            if isActive {
                if isUserRegistered {
                    MainView() // 主界面视图
                } else {
                    SignUpView()
                }
            } else {
                ZStack {
                    Color(.systemBackground)
                        .edgesIgnoringSafeArea(.all) // 背景色

                    VStack {
                        Text("ParaDigi")
                            .font(.system(size: 64, weight: .black))
                            .foregroundStyle(Color(.label))
                        
                        Text("Welcome to Our World")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.label))
                    }
                }
                .onTapGesture {
                    withAnimation {
//                        checkPrivateKeyInKeychain()
                        checkUserStatus()
                    }
                }
                .onAppear {
                    // 延迟 3 秒后跳转到主界面
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            checkUserStatus()
                        }
                    }
                }
            }
        }
    }
    
    // 检查用户的注册状态
    private func checkUserStatus() {
        isActive = true
    }
}

//struct SplashScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashScreenView()
//    }
//}

