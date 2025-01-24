//
//  AvatarTestView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/24.
//

import SwiftUI
import UIKit

// 生成随机色块图像的函数
func generateRandomBlockImage(size: CGSize, blocks: Int) -> UIImage? {
    // 创建一个图形上下文
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    // 获取上下文
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }

    // 随机生成色块
    for _ in 0..<blocks {
        // 随机颜色
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )

        // 随机位置和大小
        let blockWidth = CGFloat.random(in: 20...100)
        let blockHeight = CGFloat.random(in: 20...100)
        let x = CGFloat.random(in: 0...(size.width - blockWidth))
        let y = CGFloat.random(in: 0...(size.height - blockHeight))

        // 设置随机颜色
        context.setFillColor(randomColor.cgColor)
        context.fill(CGRect(x: x, y: y, width: blockWidth, height: blockHeight))
    }

    // 从上下文中生成图像
    let image = UIGraphicsGetImageFromCurrentImageContext()

    // 结束上下文
    UIGraphicsEndImageContext()

    return image
}

// 将图像转换为 Base64 字符串
func imageToBase64(image: UIImage) -> String? {
    guard let imageData = image.pngData() else {
        return nil
    }
    return imageData.base64EncodedString()
}

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
            if let image = generateRandomBlockImage(size: CGSize(width: 200, height: 200), blocks: 10) {
                generatedImage = image
                base64ImageString = imageToBase64(image: image) // 获取图像的 Base64 字符串
            }
        }
    }
}

