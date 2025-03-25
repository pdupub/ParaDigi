//
//  UserRow.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//

import SwiftUI

// 用户列表行组件
struct UserRow: View {
    let user: StdUser
    
    var body: some View {
        HStack {
            user.avatarImage
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 3)
            
            VStack(alignment: .leading) {
                Text(user.nickname)
                    .font(.headline)
                Text("Posts: \(user.nonce) | Following: \(user.followCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(lastUpdateString(from: user.lastUpdate))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
    
    // 格式化最后更新时间
    private func lastUpdateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
