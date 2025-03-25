//
//  TopTabButton.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/25.
//
import SwiftUI

// Tab按钮组件
struct TopTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isSelected ? .blue : .gray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
        }
    }
}
