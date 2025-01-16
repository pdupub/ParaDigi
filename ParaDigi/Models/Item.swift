//
//  Item.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//


import SwiftData
import Foundation // 必须导入 Foundation 才能使用 UUID

@Model
final class Item: Identifiable {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var text: String // 用于保存用户输入内容

    // 显式初始化方法
    init(id: UUID = UUID(), timestamp: Date, text: String) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
    }
}

