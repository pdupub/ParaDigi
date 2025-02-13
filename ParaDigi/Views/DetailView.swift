//
//  DetailView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct DetailView: View {
    let uq: UnsignedQuantum // 接收选中的 Item

    var body: some View {
        VStack {
            Text(String(data: uq.contents![0].data!, encoding: .utf8)!)
                .font(.title)
                .padding()
                .multilineTextAlignment(.leading) // 多行文字对齐
            Spacer()
        }
    }
}
