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
        var displayImages : [UIImage] = []
        if let cs = quantum.unsignedQuantum.contents {
            for content in cs {
                if content.format == "base64" {
                    if let imageData = Data(base64Encoded: content.displayText) {
                        if let uiImage = UIImage(data: imageData) {
                            displayImages.append(uiImage)
                        }
                    }
                }
            }
        }
        
        return displayImages
    }
    
    func isImgExist() -> Bool {
        if let cs = quantum.unsignedQuantum.contents {
            for content in cs {
                if content.format == "base64" {
                    return true
                }
            }
        }
        return false
    }
    
    // 自定义方法返回字符串内容
    func getDisplayTxt() -> String {
        var displayTxt = ""
        if quantum.unsignedQuantum.type == 1 {
            displayTxt = "Update User Profile"
        }
        if let cs = quantum.unsignedQuantum.contents {
            for content in cs {
                if content.format == "txt" {
                    displayTxt += content.displayText + "\n"
                }
            }
        }
        
        return displayTxt
    }
    
}
