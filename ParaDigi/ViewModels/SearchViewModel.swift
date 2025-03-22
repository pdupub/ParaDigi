//
//  SearchViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/25.
//


import SwiftUI
import SwiftData

class SearchViewModel: ObservableObject {
    
    @Published var qs :  [SignedQuantum] = []
    private var modelContext: ModelContext? // 直接持有 modelContext
    private var userInfoDict: [String: [String: QContent]] = [:] // 存储每个 signer 的用户信息
    @Published var searchText: String = "" // 新增属性，用于存储搜索文本

    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func search(_ keyword : String) {
        self.qs = QuantumManager.searchQauntumsByKeyword(keyword, modelContext: self.modelContext)
    }

    
    func fetchUserInfo(for signer: String, modelContext: ModelContext) -> [String: QContent]?{
        if !self.userInfoDict.keys.contains(signer) {
            let userInfo = QuantumManager.getUserInfo(signer:signer, modelContext: modelContext)
            if !userInfo.isEmpty {
                // update userInfoDict
                self.userInfoDict[signer] = userInfo
            }
        }
        return self.userInfoDict[signer]
    }
    
}
