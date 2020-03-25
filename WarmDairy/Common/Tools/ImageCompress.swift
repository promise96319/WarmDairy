//
//  ImageCompress.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/24.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class ImageCompressTool {
    /// 压缩图片
    /// - Parameters:
    ///   - image: UIImagee
    ///   - size: 图片大小，单位 KB
    static func compress(image: UIImage, to size: Int) -> Data? {
        var compression: CGFloat = 1
        let maxLength = size * 1024
        guard var data = image.jpegData(compressionQuality: 1) else { return nil }
        
        if data.count < maxLength {
            return data
        }
        CLog("压缩前\(data.count/1024)KB")
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        CLog("压缩后\(data.count/1024)KB")
        if data.count < maxLength {
            return data
        }
        
        var resultImage = UIImage(data: data)!
        
        var lastDataLength = 0
        while (data.count > maxLength && data.count != lastDataLength) {
            lastDataLength = data.count
            //获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat(data.count);
            let sqrRatio = CGFloat(sqrtf(Float(ratio)))
            let toSize = CGSize(width: (resultImage.size.width * sqrRatio), height: (resultImage.size.height * sqrRatio))
            
            UIGraphicsBeginImageContext(toSize)
            //通过图片上下文进行处理图片
            resultImage.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
            //获取处理后图片的大小
            data = resultImage.jpegData(compressionQuality: compression)!;
        }
        CLog("最终压缩: \(data.count/1024)KB")
        return data
    }
    
    static func resize(image: UIImage, to size: CGSize) -> UIImage? {
        if image.size.height > size.height {
            
            let width = size.height / image.size.height * image.size.width
            
            let newImgSize = CGSize(width: width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            image.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
            
        } else {
            
            let newImgSize = CGSize(width: size.width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            image.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
        }
    }
}
