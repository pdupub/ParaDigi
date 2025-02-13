//
//  QContent.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import SwiftData
import Foundation

@Model
class QContent {
    @Attribute(.unique) var id: UUID = UUID()  // 确保每条数据唯一
    var data: Data? // 存储 AnyCodable 为 Data 格式
    var format: String

    init(data: AnyCodable, format: String) {
        self.format = format
        self.data = try? JSONEncoder().encode(data)
    }

    // 解码 `data` 为 AnyCodable
    func getDecodedData() -> AnyCodable? {
        guard let data = self.data else { return nil }
        return try? JSONDecoder().decode(AnyCodable.self, from: data)
    }
}

// 处理 QContent.Data (存储任意类型)
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self.value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            self.value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
        } else {
            throw DecodingError.typeMismatch(
                AnyCodable.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported type")
            )
        }
    }
}
