//
//  SelectedImageView.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/21.
//


import SwiftUI

// SelectedImageView.swift
struct SelectedImageView: View {
    var images: [UIImage]  // 接受一个图片数组
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            switch images.count {
            case 1:
                // 如果是一张图，直接显示
                Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: images[0], targetAspectRatio: 16/9))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
            case 2:
                // 两张图，裁切到 8:9，横向排布
                HStack(spacing: 0) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: image, targetAspectRatio: 8/9))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width / 2, height: height)
                            .clipped()
                    }
                }
            case 3:
                // 三张图，左边一张，右边两张竖着排布，整体 16:9
                HStack(spacing: 0) {
                    Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: images[0], targetAspectRatio: 16/9))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width / 2, height: height)
                        .clipped()
                    
                    VStack(spacing: 0) {
                        ForEach(images.suffix(from: 1), id: \.self) { image in
                            Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: image, targetAspectRatio: 8/9))
                                .resizable()
                                .scaledToFill()
                                .frame(width: width / 2, height: height / 2)
                                .clipped()
                        }
                    }
                }
            case 4:
                // 四张图，分两行，每行两张，整体矩形
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(images.prefix(2), id: \.self) { image in
                            Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: image, targetAspectRatio: 8/9))
                                .resizable()
                                .scaledToFill()
                                .frame(width: width / 2, height: height / 2)
                                .clipped()
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(images.suffix(2), id: \.self) { image in
                            Image(uiImage: ImageUtilities.cropImageToAspectRatio(image: image, targetAspectRatio: 8/9))
                                .resizable()
                                .scaledToFill()
                                .frame(width: width / 2, height: height / 2)
                                .clipped()
                        }
                    }
                }
            default:
                EmptyView()
            }
        }
    }
}
