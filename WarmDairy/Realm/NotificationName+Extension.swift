//
//  NotificationName+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    /// 日记被添加了
    static let categoryDidChanged = Notification.Name("categoryDidChanged")
    
    /// 用户信息被更改了
    static let userInfoDidChanged = Notification.Name("userInfoDidChanged")
    
    /// 购买成功通知
    static let purchaseDidSuccessed = Notification.Name("purchaseDidSuccessed")
}
