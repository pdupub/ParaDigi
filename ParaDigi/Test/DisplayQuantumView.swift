//
//  DisplayQuantumView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftUI
import SwiftData

struct DisplayQuantumView: View {
    @Query(sort: \UnsignedQuantum.nonce, order: .forward) private var uqs: [UnsignedQuantum] // 按照nonce排序

    var body: some View {

            NavigationView {
                List(uqs) { uq in
                        
                        VStack(alignment: .leading) {
                            Text(uq.last) // 显示保存的内容
                                .font(.headline)
                            Text(String(data: uq.contents![0].data!, encoding: .utf8)!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    
                }
            }
        }
}

