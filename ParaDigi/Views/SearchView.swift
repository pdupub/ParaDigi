//
//  SearchView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//
import SwiftUI

struct SearchView: View {
    @State private var searchText = "" // 用于存储输入框的内容
    @StateObject private var viewModel = SearchViewModel() // 引用ViewModel
    @Environment(\.modelContext) private var modelContext // 获取数据上下文
    var body: some View {
        VStack {
            // 顶部的单行输入框
            TextField("Search...", text: $searchText, onCommit: {
                viewModel.search(searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle()) // 使用圆角样式
            .padding()
            .submitLabel(.search) // 将键盘上的“Return”按钮改为“Search”
            .onAppear{
                viewModel.setModelContext(modelContext: modelContext)
            }
            
            NavigationView {
                List(viewModel.qs) { quantum in
                    if let user = viewModel.fetchUserInfo(for: quantum.signer!, modelContext: modelContext) {
                        NavigationLink(destination: FeedDetailView(quantum: quantum, userInfo: user )) {
                            VStack(alignment: .leading) {
                                QuantumRowView(quantum: quantum, userInfo: user)
                                
                            }
                        }
                        .listRowInsets(EdgeInsets())

                    }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear {
                // 当视图出现时，自动使 TextEditor 获取焦点
                viewModel.setModelContext(modelContext: modelContext)
            }

            
            Spacer()

//            Text("Search Results for: \(searchText)") // 显示搜索内容，模拟搜索结果
//                .font(.title2)
//                .foregroundColor(Color.primary)
//                .padding()
        }
    }

}
