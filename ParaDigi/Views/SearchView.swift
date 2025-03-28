//
//  SearchView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel() // 引用ViewModel
    @Environment(\.modelContext) private var modelContext // 获取数据上下文
    @State private var navigationPath = NavigationPath()

    var body: some View {
        VStack {

            NavigationStack(path: $navigationPath) {
                VStack{
                    if navigationPath.isEmpty {
                        
                            // 顶部的单行输入框
                            TextField("Search...", text: $viewModel.searchText, onCommit: {
                                viewModel.search(viewModel.searchText)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // 使用圆角样式
                            .padding()
                            .submitLabel(.search) // 将键盘上的“Return”按钮改为“Search”
                        
                        if viewModel.qs.count == 0 {
                            
                            VStack {
                                Text("\"The real voyage of discovery consists not in seeking new landscapes, but in having new eyes.\"")
                                    .font(.body) // 正文字体，大小适中
                                    .foregroundColor(.gray) // 灰色，柔和不刺眼
                                    .multilineTextAlignment(.center) // 居中对齐
                                    .padding(.horizontal, 40) // 水平留白，增加可读性
                                
                                Text("— Marcel Proust")
                                    .font(.footnote) // 较小的字体用于署名
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            }
                            .padding()
                        }
                    }
                    List{
                        ForEach(viewModel.qs) { quantum in
                            if let user = viewModel.fetchUserInfo(for: quantum.signer!, modelContext: modelContext) {
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
                                    //                                viewModel.refreshData()
                                }
                        }
                    }
                }
            }
            .onAppear {
                // 当视图出现时，自动使 TextEditor 获取焦点
                viewModel.setModelContext(modelContext: modelContext)
            }

            Spacer()

        }
    }

}
