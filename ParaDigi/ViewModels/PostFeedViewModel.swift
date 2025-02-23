//
//  AddTextViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftUI
import SwiftData

class PostFeedViewModel: ObservableObject {
    private var modelContext: ModelContext? // 直接持有 modelContext
    @Published var textContent: String = "" // 绑定的输入文本

    private var quantumManager: QuantumManager

    init() {
        self.quantumManager = QuantumManager()
    }
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveItem(images: [UIImage]) {
        guard let modelContext = modelContext else { return }
        var contents = [QContent]()

        if !textContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // 创建 QContent 数据对象
            let txtContent = QContent(order:0, data: AnyCodable(textContent), format: "txt")
            contents.append(txtContent)
        }

        // 添加图片处理
        for img in images {
            if let compressedImg = img.compressToFit(maxSize: 64) {
                if let base64Img = ImageUtilities.imageToBase64(image:compressedImg){
                    let imgContent = QContent(order:0, data: AnyCodable(base64Img), format: "base64")
                    contents.append(imgContent)
                }
            }
        }

        if contents.count == 0 { return }
        
        guard let signedQuantum = self.quantumManager.createSignedQuantum(contents, qtype: Constants.quantumTypeInformation, modelContext: modelContext) else {
            print("create signedQuantum fail")
            return
        }
        
        
//        let verifyResult = QuantumManager.verifyQuantumSignature(signedQuantum)
//        print("verify result is : \(verifyResult)")
//        print("signature is : \(signedQuantum.signature)")
//        print("address is : \(signedQuantum.signer)")
//        
//        
//        print("====================================")
        
        self.quantumManager.saveQuantumToLocal(signedQuantum, modelContext: modelContext)
        print("save quantum to local success")
        
    }
    
    func fetchDefaultUserInfo(modelContext: ModelContext) -> [String: QContent]?{
        guard let signer = self.quantumManager.getCurrentSigner() else { return nil }
        return self.quantumManager.getUserInfo(signer:signer, modelContext: modelContext)
    }
}
