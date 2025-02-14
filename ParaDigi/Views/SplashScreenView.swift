//
//  SplashScreenView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/14.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                MainView() // 主界面视图
            } else {
                ZStack {
                    Color.blue
                        .edgesIgnoringSafeArea(.all) // 背景色

                    VStack {
                        Image(systemName: "app.fill") // 可以替换为自定义 logo
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding()

                        Text("Welcome to ParaDigi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .onAppear {
                    // 延迟 3 秒后跳转到主界面
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

