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
    var references: [String] 
    var type: Int?


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
        try container.encode(references, forKey: .references)
        
    }
    
    // 定义 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case contents, last, nonce, references, type
    }
    
    // 用于排序内容
    func sortedContents() -> [QContent]? {
        if self.contents == nil { return nil }
        return self.contents!.sorted { $0.id < $1.id }
    }
}
@Model
class SignedQuantum: Identifiable, Encodable {
    @Attribute(.unique) var id: UUID
    var unsignedQuantum: UnsignedQuantum
    var signature: String?
    var signer: String?

    init(unsignedQuantum: UnsignedQuantum, signature: String?, signer: String?) {
        self.unsignedQuantum = unsignedQuantum
        self.signature = signature
        self.signer = signer
        
        let millisecondsSince1970 = Int64(Date().timeIntervalSince1970 * 1000)
        let millisecondsString = String(millisecondsSince1970)
        let fakeUUIDPrefix = String(millisecondsString.prefix(8) + "-" + millisecondsString.dropFirst(8).prefix(4))
        
        // 保证UUID前面的部分是时间戳
        let uuidString = fakeUUIDPrefix + UUID().uuidString.suffix(23)
        self.id = UUID(uuidString: uuidString)!
    }
    
    // 实现 Encodable 协议
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // 编码其他属性
        try container.encode(unsignedQuantum, forKey: .unsignedQuantum)
        try container.encode(signature, forKey: .signature)
        try container.encode(signer, forKey: .signer)

    }
    
    // 定义 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case unsignedQuantum, signature, signer
    }
}
