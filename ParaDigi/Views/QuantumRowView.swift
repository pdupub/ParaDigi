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

    // 创建一个 view model 实例
    @StateObject private var viewModel: QuantumRowViewModel
    
    init(quantum: SignedQuantum, userInfo: [String: QContent]?) {
        self.quantum = quantum
        self.userInfo = userInfo
        _viewModel = StateObject(wrappedValue: QuantumRowViewModel(quantum: quantum, userInfo: userInfo))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AvatarView(avatarBase64: viewModel.userAvatar)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(viewModel.userNickName)
                                   .font(.subheadline)
                                   .foregroundColor(viewModel.userNickName == "Loading user info..." ? .gray : .primary)
                               
                   Text(viewModel.userName)
                       .font(.subheadline)
                       .lineLimit(1)
                       .truncationMode(.middle)
                       .foregroundColor(.gray)
                }
                
                Text(viewModel.displayContent)
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
