//
//  Quantum.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftData
import Foundation

@Model
class UnsignedQuantum: Identifiable, Encodable {
    @Attribute(.unique) var id: UUID = UUID()
    var contents: [QContent]?
    var last: String
    var nonce: Int
    var referencesData: Data? // ⚠️ 存储为 Data
    var type: Int?

    // 存储 references 数组为 Data 类型
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

    // 实现 Encodable 协议
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // 编码其他属性
        try container.encode(contents, forKey: .contents)
        try container.encode(last, forKey: .last)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(type, forKey: .type)
        
        // 编码 references 字段时，先解码为字符串数组后进行编码
        if let referencesData = self.referencesData {
//            try container.encode(referencesData, forKey: .referencesData)
            try container.encode(references, forKey: .references)
        }
    }
    
    // 定义 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case contents, last, nonce, references, type
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
