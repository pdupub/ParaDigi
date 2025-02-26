//
//  FeedActionsView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/26.
//

import SwiftUI

// 新定义的 FeedActionsView 用于显示评论、转发、点赞和收藏的图标和数字
struct FeedActionsView: View {
    var commentCount: Int
    var shareCount: Int
    var likeCount: Int
    var favoriteCount: Int

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                // 处理评论按钮点击事件
            }) {
                HStack {
                    Image(systemName: "message")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    Text("\(commentCount)") // 使用传入的评论数量
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            Button(action: {
                // 处理转发按钮点击事件
            }) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    Text("\(shareCount)") // 使用传入的转发数量
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            Button(action: {
                // 处理点赞按钮点击事件
            }) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    Text("\(likeCount)") // 使用传入的点赞数量
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: {
                // 处理收藏按钮点击事件
            }) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    Text("\(favoriteCount)") // 使用传入的收藏数量
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
