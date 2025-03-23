//
//  ParaDigiApp.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI
import SwiftData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ParaDigiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {

        let schema = Schema([
            QContent.self,
            UnsignedQuantum.self,
            SignedQuantum.self
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
//            MainView()
            SplashScreenView() // 设置启动时的 SplashScreen 视图
//                .preferredColorScheme(.light)
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
                HomeFeedView()
            case .search:
                SearchView()
            case .testing:
//                FBTestingView()
                CryptoTestView()
//                AnimateView()
//                SignUpView()
//                PrivateKeyLoginView()
            case .profile:
                ProfileView()
            }
            Spacer()
            // Tab bar at the bottom
            HStack {
                Spacer()
                TabButton(tab: .home, selectedTab: $selectedTab)
                Spacer()
                Spacer()

                TabButton(tab: .search, selectedTab: $selectedTab)
                Spacer()
                Spacer()

                TabButton(tab: .testing, selectedTab: $selectedTab)
                Spacer()
                Spacer()

                TabButton(tab: .profile, selectedTab: $selectedTab)
                Spacer()
            }
            .padding()
            .padding(.bottom, -16)
            .background(Color(UIColor.systemGray6))
        }
    }
}

enum Tab: String {
    case home = "house.fill"
    case search = "magnifyingglass"
    case testing = "questionmark.circle"
    case profile = "person.circle.fill"
}



