//
//  SearchView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//
import SwiftUI

struct SearchView: View {
    @State private var searchText = "" // 用于存储输入框的内容

    var body: some View {
        VStack {
            // 顶部的单行输入框
            TextField("Search...", text: $searchText, onCommit: {
                performSearch() // 当用户点击键盘上的“Search”按钮时触发
            })
            .textFieldStyle(RoundedBorderTextFieldStyle()) // 使用圆角样式
            .padding()
            .submitLabel(.search) // 将键盘上的“Return”按钮改为“Search”
            
            Spacer()

            Text("Search Results for: \(searchText)") // 显示搜索内容，模拟搜索结果
                .font(.title2)
                .foregroundColor(Color.primary)
                .padding()
        }
    }

    private func performSearch() {
        // 执行搜索逻辑
        print("Searching for: \(searchText)")
    }
}
