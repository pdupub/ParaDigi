//
//  QuantumManager.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/16.
//

import Foundation
import SwiftData
import Firebase

class QuantumManager {

    // 发布一个新的 Quantum 到本地数据库和 Firebase
    func publishQuantum(_ quantum: SignedQuantum, modelContext: ModelContext? ) {
        // 保存 Quantum 到本地 SwiftData
        saveQuantumToLocal(quantum, modelContext: modelContext)
        
        // 发送 Quantum 到 Firebase
//        sendQuantumToFirebase(quantum)
    }
    
    func fetchAllQuantums(modelContext: ModelContext? ) -> [SignedQuantum] {
        guard let modelContext = modelContext else { return []}
        let descriptor = FetchDescriptor<SignedQuantum>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    
    // 查询某个 signer 的地址，并按 nonce 排序，取第一个
    func getSignerWithMaxNonce(signer: String, modelContext: ModelContext?) -> SignedQuantum? {
        guard let modelContext = modelContext else { return nil }
                                                                                                                        
        let descriptor = FetchDescriptor<SignedQuantum>(
            predicate: #Predicate { $0.signer == signer },
            sortBy: [SortDescriptor(\.unsignedQuantum.nonce, order: .reverse)] // 按年龄降序
        )
                                                                                                                
        do {
            let quantums = try modelContext.fetch(descriptor)
            return quantums.first
        } catch {
            print("Error fetching quantum data: \(error)")
            return nil
        }
    }
    
    // 保存 Quantum 到本地 SwiftData
    private func saveQuantumToLocal(_ quantum: SignedQuantum, modelContext: ModelContext? ) {
        // SwiftData 存储逻辑
        guard let modelContext = modelContext else { return }
        modelContext.insert(quantum)
 
    }
    
    // 发送 Quantum 到 Firebase
    private func sendQuantumToFirebase(_ quantum: SignedQuantum) {
        let ref = Database.database().reference().child("quantums")
        let quantumData = try? JSONEncoder().encode(quantum)
        ref.child(quantum.id.uuidString).setValue(quantumData)
    }

}
