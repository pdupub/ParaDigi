//
//  HomeView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI
import SwiftData
import Firebase

struct HomeFeedView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = HomeFeedViewModel()
    @State private var showAddTextView = false
    @Environment(\.modelContext) private var modelContext
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                NavigationStack(path: $navigationPath) {
                    List {
                        ForEach(viewModel.qs) { quantum in
                            if let user = viewModel.fetchUserInfo(for: quantum.signer!, modelContext: modelContext) {
                                // 使用 ZStack 移除尖括号
                                ZStack {
                                    NavigationLink(value: quantum, label: {
                                        EmptyView() // 隐藏默认的尖括号
                                    })
                                    .opacity(0) // 确保 NavigationLink 不显示任何视觉元素
                                    
                                    // 自定义点击区域
                                    Button(action: {
                                        navigationPath.append(quantum) // 手动推送导航
                                    }) {
                                        VStack(alignment: .leading) {
                                            QuantumRowView(quantum: quantum, userInfo: user)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle()) // 移除按钮的默认样式
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowSeparatorTint(.gray)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationDestination(for: SignedQuantum.self) { quantum in
                        if let user = viewModel.fetchUserInfo(for: quantum.signer!, modelContext: modelContext) {
                            FeedDetailView(quantum: quantum, userInfo: user)
                                .onDisappear {
                                    viewModel.refreshData()
                                }
                        }
                    }
                }
                .onAppear {
                    viewModel.setModelContext(modelContext: modelContext)
                }
            }
            
            if navigationPath.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddTextView = true
                            print("Firebase App Name: \(FirebaseApp.app()?.name ?? "No App")")
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 60, height: 60)
                                .background(Color.primary)
                                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                .foregroundColor(.white)
                                .opacity(0.85)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTextView, onDismiss: {
            viewModel.refreshData()
        }) {
            PostFeedView()
        }
    }
}
