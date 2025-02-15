//
//  Quantum.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftData
import Foundation

@Model
class UnsignedQuantum{
    @Attribute(.unique) var id: UUID = UUID()
    var contents: [QContent]?
    var last: String
    var nonce: Int
    var referencesData: Data? // ⚠️ 存储为 Data
    var type: Int?

    var references: [String] {
        get {
            guard let data = referencesData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            referencesData = try? JSONEncoder().encode(newValue)
        }
    }

    init(contents: [QContent]?, last: String, nonce: Int, references: [String], type: Int?) {
        self.contents = contents
        self.last = last
        self.nonce = nonce
        self.references = references
        self.type = type
    }
}

@Model
class SignedQuantum {
    @Attribute(.unique) var id: UUID = UUID()
    var unsignedQuantum: UnsignedQuantum
    var signature: String?
    var signer: String?

    init(unsignedQuantum: UnsignedQuantum, signature: String?, signer: String?) {
        self.unsignedQuantum = unsignedQuantum
        self.signature = signature
        self.signer = signer
    }
}
