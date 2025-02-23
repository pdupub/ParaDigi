//
//  DetailView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct FeedDetailView: View {
    let quantum: SignedQuantum // 接收选中的 Item
    var userInfo: [String: QContent]? // 用户信息作为参数传入

    // 创建一个 view model 实例
    @StateObject private var viewModel: QuantumRowViewModel
    init(quantum: SignedQuantum, userInfo: [String: QContent]?) {
        self.quantum = quantum
        self.userInfo = userInfo
        _viewModel = StateObject(wrappedValue: QuantumRowViewModel(quantum: quantum, userInfo: userInfo))
    }
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                    AvatarView(avatarBase64: viewModel.avatar)

                    Text(viewModel.nickName)
                                   .fontWeight(.bold)
                                   .foregroundColor(viewModel.nickName == "Loading user info..." ? .gray : .primary)
                               
                    Text(viewModel.signature)
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
                    .cornerRadius(10)  // 设置圆角
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)  // 添加阴影
            }
            
            Spacer()
           
        }
    }
}
