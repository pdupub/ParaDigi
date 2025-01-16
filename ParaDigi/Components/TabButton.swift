//
//  TabButton.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(systemName: tab.rawValue)
                .font(.system(size: 24))
                .foregroundColor(selectedTab == tab ? Color.primary :  Color.secondary)
        }
    }
}


