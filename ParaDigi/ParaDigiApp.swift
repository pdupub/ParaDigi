//
//  ParaDigiApp.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI
import SwiftData

@main
struct ParaDigiApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct MainView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack {
            // Main content changes based on the selected tab
            switch selectedTab {
            case .home:
                HomeView()
            case .search:
                SearchView()
            case .messages:
                MessagesView()
            case .settings:
                SettingsView()
            }
            Spacer()
            // Tab bar at the bottom
            HStack {
                TabButton(tab: .home, selectedTab: $selectedTab)
                Spacer()
                TabButton(tab: .search, selectedTab: $selectedTab)
                Spacer()
                TabButton(tab: .messages, selectedTab: $selectedTab)
                Spacer()
                TabButton(tab: .settings, selectedTab: $selectedTab)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
    }
}

enum Tab: String {
    case home = "house.fill"
    case search = "magnifyingglass"
    case messages = "envelope.fill"
    case settings = "gearshape.fill"
}



