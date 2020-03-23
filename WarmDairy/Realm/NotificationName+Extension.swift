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
    
    static let userInfoDidChanged = Notification.Name("userInfoDidChanged")
}
