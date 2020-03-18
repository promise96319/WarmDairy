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
    
    /// "2020-02-03" 最后一次启动app 的日期，如果不是今天，则创建格言model
    static let lastActiveDate = DefaultsKey<String>("lastActiveDate")
    static let todayMottoImage = DefaultsKey<String>("todayMottoImage")
    static let todayMotto = DefaultsKey<String>("todayMotto")
    static let todayMottoAuthor = DefaultsKey<String>("todayMottoAuthor")
}
