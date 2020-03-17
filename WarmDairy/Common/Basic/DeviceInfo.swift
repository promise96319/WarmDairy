//
//  DeviceInfo.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

// MARK: - Common Const
public struct DeviceInfo {
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 当前scale
    public static let scale = UIScreen.main.scale
    
    /// 状态栏高度
    public static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    /// 导航栏高度
    public static let navigationBarHeight = UIApplication.shared.statusBarFrame.height + 44.0
    
    /// tabbar高度
    public static let tabbarHeight: CGFloat = 49.0
    
    /// 是否3.5寸屏
    public static let isInch35 = (320 == screenWidth && 480 == screenHeight)
    
    /// 是否4.0寸屏
    public static let isInch40 = (320 == screenWidth && 568 == screenHeight)
    
    /// 是否4.7寸屏
    public static let isInch47 = (375 == screenWidth && 667 == screenHeight)
    
    /// 是否5.5寸屏
    public static let isInch55 = (414 == screenWidth && 736 == screenHeight)
    
    /// 是否5.8寸屏
    public static let isInch58 = (375 == screenWidth && 812 == screenHeight)
    
    /// 是否iPhone
    public static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
    
    /// 是否iPad
    public static let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    /// 是否iPhoneX, XR, XS, XMax
    public static let isIphoneX = (screenHeight == 812 || screenHeight  == 896)
    
    /// 顶部安全区域高度
    public static let topSafeAreaHeight = DeviceInfo.isIphoneX ? 44 : 20
    /// 底部安全区高度
    public static let bottomSafeAreaHeight = DeviceInfo.isIphoneX ? 34 : 0
    
    /// 是否iPhone5s或更小的设备
    public static let isIphone5sOrEarlier = 568 >= screenHeight
    
    @available(iOS 11.0, *)
    public static let isIphoneXOrLastest = UIApplication.shared.keyWindow!.safeAreaInsets.bottom > 0
    
    /// UDID
//    public static var udid: String {
//        let keychain = Keychain(service: AppInfo.bundleID)
//        if let savedUDID = keychain["udid"] {
//            return savedUDID
//        } else {
//            let newUDID = UUID().uuidString
//            keychain["udid"] = newUDID
//            return newUDID
//        }
//    }
    
    /// 设备型号
    public static let model = UIDevice.current.model
    
    // 设备具体型号
    public static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":
            if DeviceInfo.isInch47 {
                return "iPhone 8"
            } else {
                return "iPhone XS Max"
            }
        case "iPhone10,2", "iPhone10,5":
            if DeviceInfo.isInch55 {
                return "iPhone 8 Plus"
            } else {
                return "iPhoneXS"
            }
            
        case "iPhone10,3":                              return "iPhoneX"
        case "iPhone10,8":                              return "iPhoneXR"
        case "iPhone10,6":                              return "iPhone XS Max"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
            
        case "AppleTV5,3":                              return "Apple TV"
            
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
            
        }
    }
    
    /// 系统版本号
    public static let systemVersion = UIDevice.current.systemVersion
    
    /// 当前语言
    public static let currentLanguage = NSLocale.preferredLanguages[0]
    
    /// 当前语言编码
    public static let currentLanguageCode = NSLocale.current.languageCode!
    
    /// 当前设置的区域编码
    public static let currentRegionCode = NSLocale.current.regionCode!
    
    /// Point To Pixel 根据机型获取像素比：1pt = 2px / 1pt = 3px
    public static var PTPScaleFactor: CGFloat {
        if DeviceInfo.modelName == "iPhone XS Max"
            || DeviceInfo.isInch58
            || DeviceInfo.isInch55 {
            return 3
        } else {
            return 2
        }
    }
}

