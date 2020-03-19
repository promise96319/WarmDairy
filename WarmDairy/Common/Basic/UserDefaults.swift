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
    
    /// 存留今天创建的motto
    static let todayMottoImage = DefaultsKey<String>("todayMottoImage")
    static let todayMotto = DefaultsKey<String>("todayMotto")
    static let todayMottoAuthor = DefaultsKey<String>("todayMottoAuthor")
}
