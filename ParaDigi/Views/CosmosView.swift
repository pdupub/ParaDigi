//
//  TrustedContactsView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/3/24.
//

import SwiftUI


// CosmosView
struct CosmosView: View {
    @State private var selectedTab: Int = 0 // 0: Trusted, 1: All Visible
    @StateObject private var viewModel = CosmosViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack {
                // Tab按钮
                HStack(spacing: 0) {
                    TopTabButton(title: "Trusted", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TopTabButton(title: "Visible", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.top, 10)
                
                // 用户列表
                List(selectedTab == 0 ? viewModel.trustedUsers : viewModel.allVisibleUsers) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserRow(user: user)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitleDisplayMode(.inline) // 设置标题为内联模式
                .ignoresSafeArea()
                .navigationTitle("Cosmos")
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext: modelContext)
        }
    }
}





//// 预览
//struct TrustedContactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrustedContactsView()
//    }
//}
