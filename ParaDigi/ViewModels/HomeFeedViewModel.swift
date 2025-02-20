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
    @Published var qs :  [SignedQuantum] = []
    private var modelContext: ModelContext? // 直接持有 modelContext
    private var userInfoDict: [String: [String: QContent]] = [:] // 存储每个 signer 的用户信息

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
    
    func fetchUserInfo(for signer: String, modelContext: ModelContext) -> [String: QContent]?{
        if !self.userInfoDict.keys.contains(signer) {
            let userInfo = self.quantumManager.getUserInfo(signer:signer, modelContext: modelContext)
            if !userInfo.isEmpty {
                // update userInfoDict
                self.userInfoDict[signer] = userInfo
            }
        }
        return self.userInfoDict[signer]
    }
    
}
