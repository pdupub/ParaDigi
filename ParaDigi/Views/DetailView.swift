//
//  DetailView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct DetailView: View {
    let item: Item // 接收选中的 Item

    var body: some View {
        VStack {
            Text(item.text) // 展示文字内容
                .font(.title)
                .padding()
                .multilineTextAlignment(.leading) // 多行文字对齐
            Spacer()
        }
    }
}
