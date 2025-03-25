//
//  CosmosViewModel.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//

import SwiftUI
import SwiftData

class CosmosViewModel: ObservableObject {
    @Published var randomImage: UIImage?
    @Published var base64ImageString: String?
    @Published var privateKey: String?

    @Published var trustedUsers: [StdUser] = []
    @Published var allVisibleUsers:[StdUser] = []
    private var modelContext: ModelContext? // 直接持有 modelContext
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        self.trustedUsers = QuantumManager.getVisibleUsers(modelContext: modelContext)
        self.allVisibleUsers = trustedUsers
    }
    
    
    
}
