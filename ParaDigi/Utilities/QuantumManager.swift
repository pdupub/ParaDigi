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
    
    func getCurrentSigner() -> String? {
        guard let privateKeyData = KeychainHelper.load(key: Constants.defaultPrivateKey) else { return nil }
        let publicKey = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        return CompatibleCrypto.generateAddress(publicKey: publicKey!)
    }
    
    func createSignedQuantum(_ contents: [QContent], qtype: Int, modelContext: ModelContext?) -> SignedQuantum? {
        guard let privateKeyData = KeychainHelper.load(key: Constants.defaultPrivateKey) else { return nil }
        let publicKey = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        let address = CompatibleCrypto.generateAddress(publicKey: publicKey!)
        
        var last = ""
        var nonce = 1
        var references: [String] = []
        var type = 0
        if qtype != 0 { type = 1}

        if let lastQuantum = getSignerWithMaxNonce(signer: address, modelContext: modelContext){
            print("query result nonce: \(lastQuantum.unsignedQuantum.nonce)")
            nonce = lastQuantum.unsignedQuantum.nonce + 1
            last = lastQuantum.signature!
            references.append(last)
        }
        let unsignedQuantum = UnsignedQuantum(contents: contents, last: last, nonce: nonce, references: references, type: type)
        //
        if let jsonData = try? JSONEncoder().encode(unsignedQuantum) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let signatureData = CompatibleCrypto.signMessage(privateKey: privateKeyData, message: jsonData)
                let signature = signatureData!.map { String(format: "%02x", $0) }.joined()
                return SignedQuantum(unsignedQuantum: unsignedQuantum, signature: signature, signer: address)
                

            }
            
        }
        return nil
    }
    
    func verifyQuantumSignature() -> Bool {
        //                if let signedData = try? JSONEncoder().encode(signedQuantum) {
        //                    if let signedString = String(data:signedData, encoding: .utf8) {
        //                        print("Encoded JSON: \(signedString)")
        //                    }
        //                }
        //
        //                let publicKeyData = CompatibleCrypto.generatePublicKey(privateKey: privateKeyData)
        //
        //                let isVerify = CompatibleCrypto.verifySignature(message: jsonData, signature: signatureData, publicKey: publicKeyData)
        //                print("Verify Signature: \(isVerify)")
        return true
    }
    
    func fetchAllQuantums(modelContext: ModelContext? ) -> [SignedQuantum] {
        guard let modelContext = modelContext else { return []}
        let descriptor = FetchDescriptor<SignedQuantum>(sortBy: [SortDescriptor(\.id, order: .reverse)] // 按年龄降序
)
        let signedQuantumList = (try? modelContext.fetch(descriptor)) ?? []
        for index in 0..<signedQuantumList.count {
            signedQuantumList[index].unsignedQuantum.contents = signedQuantumList[index].unsignedQuantum.sortedContents()
        }
        return signedQuantumList
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
            guard let lastQuantum = quantums.first else {return nil}
            lastQuantum.unsignedQuantum.contents = lastQuantum.unsignedQuantum.sortedContents()
            return lastQuantum
        } catch {
            print("Error fetching quantum data: \(error)")
            return nil
        }
    }
    
    // 保存 Quantum 到本地 SwiftData
    func saveQuantumToLocal(_ quantum: SignedQuantum, modelContext: ModelContext? ) {
        // SwiftData 存储逻辑
        guard let modelContext = modelContext else { return }
        modelContext.insert(quantum)
        do {
            // 保存到数据库
            try modelContext.save()
        } catch {
            print("保存数据时发生错误: \(error)")
        }
    }
    
    // 发送 Quantum 到 Firebase
    func sendQuantumToFirebase(_ quantum: SignedQuantum) {
        let ref = Database.database().reference().child("quantums")
        let quantumData = try? JSONEncoder().encode(quantum)
        ref.child(quantum.id.uuidString).setValue(quantumData)
    }

    func getUserInfo(signer: String, modelContext: ModelContext?) -> [String:QContent]{
        var userInfoDict : [String:QContent] = [:]
        
        guard let modelContext = modelContext else { return userInfoDict}
                                                                                                                        
        let descriptor = FetchDescriptor<SignedQuantum>(
            predicate: #Predicate { $0.signer == signer && $0.unsignedQuantum.type == 1 }, // Constants.quantumTypeIntegration},
            sortBy: [SortDescriptor(\.unsignedQuantum.nonce, order: .forward)] // 按年龄降序
        )
  
                                                                                                                
        do {
            let quantums = try modelContext.fetch(descriptor)
            for quantum in quantums{
                if let contents = quantum.unsignedQuantum.contents {
                    // 遍历每个 quantum 的 contents
                    for index in stride(from: 0, to: contents.count, by: 2) {
                        let content = contents[index]

                        // 只有偶数索引的 QContent 且 format 为 "key" 才处理
                        if content.format == "key" {
                            // 获取紧接着的奇数索引的 QContent 作为 value
                            if index + 1 < contents.count {
                                userInfoDict[content.displayText] = contents[index + 1]
                            }
                        }
                    }
                }
            }
            
        } catch {
            print("Error fetching quantum data: \(error)")
        }
        return userInfoDict
    }
}
