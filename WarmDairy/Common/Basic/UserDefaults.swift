//
//  UserDefaults.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    /// 是否VIP
    static let isVIP = DefaultsKey<Bool>("isVIP")
    static let isLifeTimeVIP = DefaultsKey<Bool>("isLifeTimeVIP")
    
    /// 订阅过期时间
    static let subscriptionExprireDate = DefaultsKey<TimeInterval>("subscriptionExprireDate")

    /// VIP 价格
    static let monthPrice = DefaultsKey<String>("monthPrice")
    static let yearPrice = DefaultsKey<String>("yearPrice")
    static let lifetimePrice = DefaultsKey<String>("lifetimePrice")
    
    /// 存留今天创建的motto
    static let todayMottoImage = DefaultsKey<String>("todayMottoImage")
    static let todayMotto = DefaultsKey<String>("todayMotto")
    static let todayMottoAuthor = DefaultsKey<String>("todayMottoAuthor")
    
    /// 最后活跃的时间，用于判断活跃天数是否加1
    static let lastActiveDay = DefaultsKey<String>("lastActiveDay")
    
    /// 图片质量 index: 0是 low , 1是中等， 2是高，3是超高
    static let imageQuality = DefaultsKey<Int>("imageQuality")
}
