//
//  AddTextViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftUI
import SwiftData

class AddTextViewModel: ObservableObject {
    private var modelContext: ModelContext? // 直接持有 modelContext
    @Published var textContent: String = "" // 绑定的输入文本
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveItem() {
        guard !textContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        guard let modelContext = modelContext else { return }
        // 创建 QContent 数据对象
        let newContent = QContent(data: AnyCodable(textContent), format: "txt")
        modelContext.insert(newContent)
//        try? modelContext.save()

        // 创建 Quantum 数据对象
        let newQuantum = UnsignedQuantum(contents: [newContent], last: "0x12345", nonce: 123, references: ["0x5678"], type: 1)
        modelContext.insert(newQuantum)
        try? modelContext.save()
    }
}
