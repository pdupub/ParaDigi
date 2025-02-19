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

    @Environment(\.colorScheme) var colorScheme // 声明环境变量，获取当前颜色模式
//    @Query(sort: \UnsignedQuantum.nonce, order: .reverse) private var uqs: [UnsignedQuantum] // 按照nonce排序
    @StateObject private var viewModel = HomeFeedViewModel() // 引用ViewModel
    @State private var showAddTextView = false // 控制跳转页面的状态
    @Environment(\.modelContext) private var modelContext // 获取数据上下文

    var body: some View {
        ZStack {
            
            
            NavigationView {
                List(viewModel.qs) { quantum in
                    NavigationLink(destination: PostDetailView(quantum: quantum)) {
                        VStack(alignment: .leading) {

                            Text(quantum.unsignedQuantum.contents![0].displayText)
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text(quantum.unsignedQuantum.last != "" ? quantum.unsignedQuantum.last : "First Quantum") // 显示保存的内容
                                .font(.subheadline)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                }
                
                .navigationTitle("Home")
                    .font(.title)
                    .foregroundColor(Color.primary)
                
            }
            .onAppear {
                // 当视图出现时，自动使 TextEditor 获取焦点
                viewModel.setModelContext(modelContext: modelContext)
                
            }

            
            
            // 悬浮按钮
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
                            .foregroundColor(colorScheme == .light ? Color.white : Color.black) // 反向图标颜色
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showAddTextView, onDismiss: {
            // 在 PostView 关闭后刷新 HomeFeedView 的数据
            viewModel.refreshData()
        }) {
            PostView() // 弹出输入页面
        }
    }
}
