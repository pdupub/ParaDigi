//
//  QuantumRowViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/21.
//


import SwiftUI

// ViewModel 用于处理 Quantum 的数据逻辑
class QuantumRowViewModel: ObservableObject {
    
    @Published var userName: String
    @Published var userNickName: String
    @Published var displayContent: String
    @Published var userAvatar: String
    
    // 初始化时传入 quantum 和 userInfo
    init(quantum: SignedQuantum, userInfo: [String: QContent]?) {
        self.userName = quantum.unsignedQuantum.last == "" ? "First Quantum" : "@\(quantum.unsignedQuantum.last)"
        self.userNickName = userInfo?["nickname"]?.displayText ?? "Loading user info..."
        self.displayContent = quantum.unsignedQuantum.contents?.first?.displayText ?? ""
        self.userAvatar = userInfo?["avatar"]?.displayText ?? ""
    }
}
