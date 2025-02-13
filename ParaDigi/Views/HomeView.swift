//
//  HomeView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
//

import SwiftUI
import SwiftData
import Firebase


struct HomeView: View {

    @Environment(\.colorScheme) var colorScheme // 声明环境变量，获取当前颜色模式
    @Query(sort: \UnsignedQuantum.nonce, order: .forward) private var uqs: [UnsignedQuantum] // 按照nonce排序

    @State private var showAddTextView = false // 控制跳转页面的状态

    var body: some View {
        ZStack {
            
            
            NavigationView {
                List(uqs) { uq in
                    NavigationLink(destination: DetailView(uq: uq)) {
                        VStack(alignment: .leading) {
                            Text(uq.last) // 显示保存的内容
                                .font(.headline)
                            Text(String(data: uq.contents![0].data!, encoding: .utf8)!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Home")
                    .font(.title)
                    .foregroundColor(Color.primary)
                
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
        .sheet(isPresented: $showAddTextView) {
            AddTextView() // 弹出输入页面
        }
    }
}
