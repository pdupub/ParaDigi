//
//  AnimateView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/20.
//

import SwiftUI

struct AnimateView: View {
    @State private var heights: [CGFloat] = [100, 150, 200, 250] // 初始高度
    private let ballDiameter: CGFloat = 30 // 球的直径

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(0..<4) { index in
                    VStack {
                        // 动态柱子和小球
                        CapsuleBar(height: heights[index], diameter: ballDiameter)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                startAnimating()
            }
        }
    }

    // 动画函数
    private func startAnimating() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                for i in 0..<heights.count {
                    heights[i] = CGFloat.random(in: 50...300)
                }
            }
        }
    }
}

struct CapsuleBar: View {
    let height: CGFloat
    let diameter: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // 顶部半球
            Circle()
                .frame(width: diameter, height: diameter)
                .offset(y: diameter / 2)

            // 柱体
            Rectangle()
                .frame(width: diameter, height: height)
            // 底部半球
            Circle()
                .frame(width: diameter, height: diameter)
                .offset(y: -diameter / 2)

        }
        .offset(y: -height/2)
        .foregroundColor(.white)
    }
}


