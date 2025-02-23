//
//  QuantumRowViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/21.
//


import SwiftUI

// ViewModel 用于处理 Quantum 的数据逻辑
class QuantumRowViewModel: ObservableObject {
    @Published var signature: String
    @Published var last: String
    @Published var nickName: String
    @Published var avatar: String
    
    private var quantum: SignedQuantum
    
    // 初始化时传入 quantum 和 userInfo
    init(quantum: SignedQuantum, userInfo: [String: QContent]?) {
        self.quantum = quantum
        self.signature = (quantum.signature?.isEmpty ?? true) ? "" : "@\(quantum.signature!)"
        self.last = quantum.unsignedQuantum.last == "" ? "First Quantum" : "@\(quantum.unsignedQuantum.last)"
        self.nickName = userInfo?["nickname"]?.displayText ?? "Loading user info..."
        self.avatar = userInfo?["avatar"]?.displayText ?? ""
    }
    
    func getDisplayImgs() -> [UIImage] {
        return QuantumManager.getDisplayImgs(quantum: quantum)
    }
    
    func isImgExist() -> Bool {
        return QuantumManager.isImgExist(quantum: quantum)
    }
    
    // 自定义方法返回字符串内容
    func getDisplayTxt() -> String {
        return QuantumManager.getDisplayTxt(quantum: quantum)
    }
    
}
