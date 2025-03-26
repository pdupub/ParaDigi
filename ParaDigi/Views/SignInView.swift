//
//  SignInView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/26.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        NavigationStack { // 用 NavigationStack 包裹内容以支持导航
            List {
                VStack {
                    Text("Welcome to Sign In Page")
                        .font(.title)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // 添加右上角的 Sign in
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    .frame(height:16)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // 隐藏返回箭头
    }
}
