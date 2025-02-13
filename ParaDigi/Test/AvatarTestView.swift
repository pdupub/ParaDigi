//
//  AvatarTestView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//

import SwiftUI


// SwiftUI 视图，显示随机生成的头像图像
struct AvatarView: View {
    @State private var base64ImageString: String? = nil
    @State private var generatedImage: UIImage? = nil

    var body: some View {
        VStack {
            if let image = generatedImage {
                // 显示生成的图像
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle()) // 使头像为圆形
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            } else {
                Text("正在生成头像...")
                    .font(.headline)
            }
            
            // 显示 Base64 字符串（如果需要）
            if let base64String = base64ImageString {
                Text(base64String)
//                Text("Base64: \(base64String.prefix(50))...") // 显示 Base64 的前 50 个字符
                    .padding()
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            // 在视图出现时生成图像
            if let image = ImageUtilities.generateRandomBlockImage(size: CGSize(width: 200, height: 200), blocks: 10) {
                generatedImage = image
                base64ImageString = ImageUtilities.imageToBase64(image: image) // 获取图像的 Base64 字符串
            }
        }
    }
}

