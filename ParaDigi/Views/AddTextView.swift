//
//  AddTextView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct AddTextView: View {
    @State private var textContent = "" // 存储输入的文字内容
    @Environment(\.dismiss) private var dismiss // 用于关闭页面

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $textContent)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color.gray, width: 1) // 添加边框用于区分输入框
                    .cornerRadius(8)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Text")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("Text saved: \(textContent)") // 替换为实际保存逻辑
                        dismiss()
                    }
                    .foregroundColor(Color.primary)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.primary)

                }
            }
        }
    }
}
