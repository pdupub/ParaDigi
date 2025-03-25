//
//  UserDetailView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//

import SwiftUI


// 用户详情页面
struct UserDetailView: View {
    let user: StdUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                user.avatarImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(user.nickname)
                        .font(.title)
                    Text("Last Updated: \(lastUpdateString(from: user.lastUpdate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            Text("Posts: \(user.nonce)")
                .font(.headline)
            Text("Following: \(user.followCount)")
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
    
    private func lastUpdateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

