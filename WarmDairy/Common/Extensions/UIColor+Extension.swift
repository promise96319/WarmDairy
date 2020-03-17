//
//  UIColor+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//
import UIKit

public extension UIColor {
    
    /// 添加随机颜色的属性
    class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 生成一个色系的渐变色组（明亮度不同）
    class var grandientColor: [CGColor] {
        get {
            let red = CGFloat(arc4random()%125 + 30)/255.0
            let green = CGFloat(arc4random()%125 + 30)/255.0
            let blue = CGFloat(arc4random()%125 + 30)/255.0
            let color1 = UIColor(red: red + 72 / 255, green: green + 72 / 255, blue: blue + 72 / 255, alpha: 1.0)
            let color2 = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            return [color1.cgColor, color2.cgColor]
        }
    }
    
    /// 带透明度的16进制色值得到颜色
    /// - Parameters:
    ///   - hexString: 16进制色值
    ///   - alpha: 透明度 0-1.0
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //判断alpha
        var kAlpha: CGFloat = 1.0
        if alpha >= 0 && alpha <= 1.0 {
            kAlpha = alpha
        }
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(kAlpha))
    }
}


