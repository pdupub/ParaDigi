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
    private var userInfoDict: [String: StdUser] = [:] // 存储每个 signer 的用户信息


    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchData()
    }

    func fetchData() {
        self.qs = QuantumManager.fetchAllQuantums(modelContext: self.modelContext)
    }
    
    func refreshData() {
        fetchData()
    }
    
    func fetchUserInfo(for signer: String, modelContext: ModelContext) -> StdUser?{
        if !self.userInfoDict.keys.contains(signer) {
            let userInfo = QuantumManager.getUserInfo(signer:signer, modelContext: modelContext)
            if userInfo != nil{
                // update userInfoDict
                self.userInfoDict[signer] = userInfo
            }
        }
        return self.userInfoDict[signer]
    }
    
}
