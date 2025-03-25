//
//  ReloadPrivateKeyView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//

import SwiftUI
import UniformTypeIdentifiers // 用于剪贴板操作

struct ReloadPrivateKeyView: View {
    @State private var isKeyVisible = false // 是否显示私钥
    @State private var isCopied = false // 是否已复制
    let privateKey: String // 从 viewModel 获取的私钥
    
    // 计算遮掩后的私钥
    private var maskedKey: String {
        if isKeyVisible {
            return privateKey
        } else {
            let totalLength = privateKey.count
            if totalLength <= 8 {
                return privateKey // 如果太短就不遮掩
            }
            let prefix = String(privateKey.prefix(4))
            let suffix = String(privateKey.suffix(4))
            let maskedMiddle = String(repeating: "*", count: totalLength - 8)
            return prefix + maskedMiddle + suffix
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            // 标题
            Text("Private Key:")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            // 文字框和按钮区域
            HStack(alignment: .center, spacing: 10) {
                // 文字框
                Text(maskedKey)
                    .font(.body.monospaced()) // 等宽字体，更适合私钥
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
                    .background(Color(.systemGray6))
                    .multilineTextAlignment(.leading)
                
                // 按钮组
                VStack(spacing: 20) {
                    // 显示/隐藏切换按钮
                    Button(action: {
                        isKeyVisible.toggle()
                    }) {
                        Image(systemName: isKeyVisible ? "eye" : "eye.slash")
                            .font(.system(size: 20))
                            .foregroundColor(isKeyVisible ? .blue : .gray)
                    }
                    
                    // 复制按钮
                    Button(action: {
                        UIPasteboard.general.setValue(privateKey, forPasteboardType: UTType.plainText.identifier)
                        withAnimation {
                            isCopied = true
                        }
                        // 3秒后恢复图标
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isCopied = false
                            }
                        }
                    }) {
                        Image(systemName: isCopied ? "doc.on.clipboard.fill" : "doc.on.clipboard")
                            .font(.system(size: 20))
                            .foregroundColor(isCopied ? .blue : .gray)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

//// 模拟 ViewModel 和预览
//struct ReloadPrivateKeyView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 假设的私钥
//        let sampleKey = "abcd1234efgh5678ijkl9012mnop3456"
//        ReloadPrivateKeyView(privateKey: sampleKey)
//    }
//}
