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
            AvatarView(avatarBase64: viewModel.avatar)
                .padding(6)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(viewModel.nickName)
                                   .font(.subheadline)
                                   .fontWeight(.bold)
                                   .foregroundColor(viewModel.nickName == "Loading user info..." ? .gray : .primary)
                               
                    Text(viewModel.signature)
                       .font(.subheadline)
                       .lineLimit(1)
                       .truncationMode(.middle)
                       .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.last)
                       .font(.subheadline)
                       .lineLimit(1)
                       .truncationMode(.middle)
                       .foregroundColor(.gray)
                       .opacity(0.3)
                                    
                }
                    
                Text(viewModel.getDisplayTxt())
                       .font(.headline)
                if viewModel.isImgExist() {
                    SelectedImageView(images: viewModel.getDisplayImgs())
                        .aspectRatio(16/9, contentMode: .fill)
                        .cornerRadius(10)  // 设置圆角
                }
            }
        }
        .padding()
    }
}

//struct QuantumRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 为预览提供数据
//        QuantumRowView(quantum: SignedQuantum())
//    }
//}
