//
//  User.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//

import SwiftUI

// 用户数据结构体
struct StdUser: Identifiable {
    var avatarBase64: String // Base64编码的头像
    var nickname: String // 用户昵称
    let address: String
    var id: String {
        address
    }
    var nonce: Int // 发帖数量
    var followCount: Int // 关注数量
    var lastUpdate: Date // 最后更新时间
    var extra: [String:QContent]
    
    // 将Base64转换为Image
    var avatarImage: Image {
        if let data = Data(base64Encoded: avatarBase64),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "person.fill")// 默认头像
    }
}
