//
//  QuantumRowView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/19.
//

import SwiftUI

struct QuantumRowView: View {
    
    var quantum: SignedQuantum // 接收一个 UnsignedQuantum 对象
    var userInfo: [String: QContent]? // 用户信息作为参数传入

    var body: some View {
        
        HStack(alignment: .top) {
            AvatarView(avatarBase64: userInfo?["avatar"]?.displayText)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    
                    if let nickName = userInfo?["nickname"] {
                        Text(nickName.displayText)
                                        .font(.subheadline)
                                } else {
                                    Text("Loading user info...")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                    }
                    
                    
                    Text(quantum.unsignedQuantum.last != "" ? "@\(quantum.unsignedQuantum.last)" : "First Quantum")
                        .font(.subheadline)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundColor(.gray)
                }
                
                Text(quantum.unsignedQuantum.contents![0].displayText)
                    .font(.headline)
            
                
            }
        }
        

    }
}

//struct QuantumRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 为预览提供数据
//        QuantumRowView(quantum: SignedQuantum())
//    }
//}
