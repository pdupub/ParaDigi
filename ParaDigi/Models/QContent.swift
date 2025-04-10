//
//  QContent.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//
import SwiftData
import Foundation

@Model
class QContent: Identifiable, Encodable {
    @Attribute(.unique) var id: UUID // 确保每条数据唯一
    var data: String? // 将 Data 转换为 String 类型存储
    var format: String
    var search: String?
    
    // 存储 AnyCodable 对象并将其转换为字符串格式
    init(order:Int, data: AnyCodable, format: String) {
        // 使用 order 来影响 UUID 的生成
        let orderPrefix = String(format: "%02X", order)  // 以16进制形式显示 order
        let randomSuffix = UUID().uuidString.dropFirst(2)  // 去掉前两个字符
        let modifiedUUIDString = orderPrefix + randomSuffix
        // 生成修改后的 UUID
        self.id = UUID(uuidString: modifiedUUIDString) ?? UUID()
        self.format = format
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        jsonEncoder.dataEncodingStrategy = .base64
        self.data = try? jsonEncoder.encode(data).base64EncodedString()  // 将 Data 转为 Base64 字符串
        
        self.search = self.displayText
    }

    // 解码 `data` 为 AnyCodable
    func getDecodedData() -> AnyCodable? {
        guard let data = self.data else { return nil }
        if let decodedData = Data(base64Encoded: data) {
            return try? JSONDecoder().decode(AnyCodable.self, from: decodedData)
        }
        return nil
    }

    // 实现 Encodable 协议
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // 编码其他字段
        try container.encode(format, forKey: .format)
        
        // 编码 `data` 字段时，将其解码为 AnyCodable 对象后进行编码
        if let decodedData = getDecodedData() {
            try container.encode(decodedData, forKey: .data)
        }
    }
    
    // 定义 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case format, data
    }
    
    // 计算属性：返回解码后的值作为可显示的字符串
    var displayText: String {
        guard let decodedData = getDecodedData() else { return "N/A" }

        if let intValue = decodedData.value as? Int {
            return "\(intValue)" // 显示整数
        } else if let doubleValue = decodedData.value as? Double {
            return "\(doubleValue)" // 显示浮点数
        } else if let stringValue = decodedData.value as? String {
            return stringValue // 显示字符串
        } else {
            return "Unsupported Type" // 处理不支持的类型
        }
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
