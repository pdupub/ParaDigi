//
//  HomeFeedViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/19.
//

import SwiftUI
import SwiftData

class HomeFeedViewModel: ObservableObject {
    
    @Published var showAddTextView = false // 控制跳转页面的状态
    private var modelContext: ModelContext? // 直接持有 modelContext
    @Published var qs :  [SignedQuantum] = []

    private var quantumManager: QuantumManager

    init() {
        self.quantumManager = QuantumManager()
    }
    
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchData()
    }

    func fetchData() {
        self.qs = self.quantumManager.fetchAllQuantums(modelContext: self.modelContext)

    }
    
    func refreshData() {
        fetchData()
    }
    
}
