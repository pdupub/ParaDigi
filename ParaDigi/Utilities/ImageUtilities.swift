//
//  ImageUtilities.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/13.
//

import UIKit
struct ImageUtilities {
    
    // 生成随机色块图像的函数
    static func generateRandomAvatarImage() -> UIImage? {
        let sideLen = CGFloat(512)
        let size = CGSize(width: sideLen, height: sideLen)
        
        // 创建一个图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 脸
        var r = CGFloat.random(in: 0.4...1)
        var randomColor = UIColor(
                red: r,
                green: r - 0.11 + CGFloat.random(in: -0.05...0.05),
                blue: r - 0.22 + CGFloat.random(in: -0.08...0.1),
                alpha: 1 // CGFloat.random(in: 0.9...1.0)
            )
        
        let blockWidth = CGFloat.random(in: (sideLen / 3.0).rounded()...(sideLen / 1.8).rounded())
        let blockHeight = (sideLen / 1.8).rounded()
        let x = (size.width - blockWidth)/2
        let y = (size.height - blockHeight)/2
        
        context.setFillColor(randomColor.cgColor)
        // 耳朵
        context.fill(CGRect(x: x-(blockWidth*0.1), y: y + (blockHeight*0.4), width: blockWidth*1.2, height: blockHeight/4))
        // 脸
        context.fill(CGRect(x: x, y: y, width: blockWidth, height: blockHeight))
        // 鼻子
        randomColor = UIColor(
                red: r,
                green: r - 0.15,
                blue: r - 0.35 ,
                alpha: 1 // CGFloat.random(in: 0.9...1.0)
            )
        context.setFillColor(randomColor.cgColor)
        let noseHeight = blockHeight * CGFloat.random(in: 0.2...0.36)
        let noseWidth = blockWidth * CGFloat.random(in: 0.2...0.25)
        context.fill(CGRect(x: x + ((blockWidth-noseWidth)/2), y: y + (((blockHeight - noseHeight)/2) * CGFloat.random(in: 1...1.2)), width: noseWidth, height: noseHeight))

        // 眼睛
        randomColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green:  CGFloat.random(in: 0...1),
                blue:  CGFloat.random(in: 0...1),
                alpha: CGFloat.random(in: 0.8...1)
            )
        context.setFillColor(randomColor.cgColor)
        let eyeHeight = noseHeight * CGFloat.random(in: 0.6...0.8)
        let eyeWidth = noseWidth * CGFloat.random(in: 1...1.2)
        let eyeY = y + ((blockHeight/5) * CGFloat.random(in: 1...1.2))
        let diffX = CGFloat.random(in: -eyeWidth...0)
        context.fill(CGRect(x: x + (blockWidth/5) + diffX, y: eyeY, width: eyeWidth, height: eyeHeight))
        context.fill(CGRect(x: x + (blockWidth * 0.8) + diffX, y:eyeY, width: eyeWidth, height: eyeHeight))
        
        // 头发
        let loopNum = Int.random(in: 4...10)
        r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...(1-r))
        let b = CGFloat.random(in: 0...(1-r-g))
        
        for _ in 1...loopNum{
            randomColor = UIColor(
                    red: r,
                    green: g,
                    blue: b,
                    alpha: CGFloat.random(in: 0.75...0.9)
                )
            context.setFillColor(randomColor.cgColor)
            context.fill(CGRect(x:x+((blockWidth/4)*CGFloat.random(in: -1...4)),y:y - ((blockHeight/20)*CGFloat.random(in: 2...8)),width: (blockWidth/CGFloat.random(in: 1...2.5)), height: (blockHeight/CGFloat.random(in: 2...4))))
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
    
    // 计算并裁切图片
    static func cropImageToAspectRatio(image: UIImage, targetAspectRatio: CGFloat) -> UIImage {
        let imageSize = image.size
        let imageAspectRatio = imageSize.width / imageSize.height
        
        // 判断图片是否需要裁切
        if abs(imageAspectRatio - targetAspectRatio) < 0.01 {
            return image // 不需要裁切
        }
        
        // 计算裁切后的宽高
        var cropRect: CGRect
        if imageAspectRatio > targetAspectRatio {  // 宽大于高
            let cropWidth = imageSize.height * targetAspectRatio
            let cropX = (imageSize.width - cropWidth) / 2
            cropRect = CGRect(x: cropX, y: 0, width: cropWidth, height: imageSize.height)
        } else {  // 高大于宽
            let cropHeight = imageSize.width / targetAspectRatio
            let cropY = (imageSize.height - cropHeight) / 2
            cropRect = CGRect(x: 0, y: cropY, width: imageSize.width, height: cropHeight)
        }
        
        // 裁切图像
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage)
        }
        
        return image // 默认返回原始图片
    }
}

extension UIImage {
    // 压缩图片到适合手机显示的尺寸，保持宽高比例
    func compressToFit(maxSize: CGFloat = 1024) -> UIImage? {
        let imageSize = self.size
        let widthRatio = maxSize / imageSize.width
        let heightRatio = maxSize / imageSize.height
        let ratio = min(widthRatio, heightRatio)
        
        // 如果图片已经小于指定尺寸，则不需要压缩
        if ratio >= 1 {
            return self
        }
        
        // 计算缩放后的尺寸
        let newWidth = imageSize.width * ratio
        let newHeight = imageSize.height * ratio
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        // 创建缩放后的图像
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressedImage
    }
}
