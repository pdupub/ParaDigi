//
//  DetailView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct PostDetailView: View {
    let uq: UnsignedQuantum // 接收选中的 Item

    var body: some View {
        VStack {
            Text(uq.contents![0].data!)
                .font(.title)
                .padding()
                .multilineTextAlignment(.leading) // 多行文字对齐
            Spacer()
        }
    }
}
