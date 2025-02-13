//
//  ImageUtilities.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import UIKit
struct ImageUtilities {
    
    // 生成随机色块图像的函数
    static func generateRandomBlockImage(size: CGSize, blocks: Int) -> UIImage? {
        // 创建一个图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 随机生成色块
        for _ in 0..<blocks {
            // 随机颜色
            let randomColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
            
            // 随机位置和大小
            let blockWidth = CGFloat.random(in: 20...100)
            let blockHeight = CGFloat.random(in: 20...100)
            let x = CGFloat.random(in: 0...(size.width - blockWidth))
            let y = CGFloat.random(in: 0...(size.height - blockHeight))
            
            // 设置随机颜色
            context.setFillColor(randomColor.cgColor)
            context.fill(CGRect(x: x, y: y, width: blockWidth, height: blockHeight))
        }
        
        // 从上下文中生成图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // 将图像转换为 Base64 字符串
    static func imageToBase64(image: UIImage) -> String? {
        guard let imageData = image.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
