//
//  AvatarView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/20.
//

import SwiftUI

struct AvatarView: View {
    var avatarBase64: String? // 接收 Base64 字符串

    var body: some View {
        if let avatarBase64 = avatarBase64 {
            // 解码 Base64 字符串为 Data
            if let imageData = Data(base64Encoded: avatarBase64) {
                if let uiImage = UIImage(data: imageData) {
                    // 显示图片
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        .shadow(radius: 3)
                } else {
                    Text("Invalid image data")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            } else {
                Text("Invalid base64 string")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        } else {
            // 如果没有 avatar，显示默认图标
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 3)
        }
    }
}
