//
//  AddTextViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftUI
import SwiftData

class PostViewModel: ObservableObject {
    private var modelContext: ModelContext? // 直接持有 modelContext
    @Published var textContent: String = "" // 绑定的输入文本
    private var quantumManager: QuantumManager

    init() {
        self.quantumManager = QuantumManager()
    }
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveItem() {
        guard !textContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        guard let modelContext = modelContext else { return }
        // 创建 QContent 数据对象
        let newContent = QContent(data: AnyCodable(textContent), format: "txt")
        
        var contents = [QContent]()
        contents.append(newContent)

        guard let signedQuantum = self.quantumManager.createSignedQuantum(contents, qtype: Constants.quantumTypeInformation, modelContext: modelContext) else {
            print("create signedQuantum fail")
            return
        }
        
        self.quantumManager.saveQuantumToLocal(signedQuantum, modelContext: modelContext)
        print("save quantum to local success")
        
    }
}
