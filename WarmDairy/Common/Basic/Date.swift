//
//  File.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import SwiftDate

/// 1. 在数据库中存储的是UTC格式
/// 2. 进行比较的时候均使用UTC格式
/// 3. 展示的时候转化成 当前时区
extension Date {
    /// 将date转化成当前时区：保证格式化后显示正确
    /// 数据库均需存储 UTC 格式 Date
    func toRegion() -> DateInRegion {
       return self.in(region: .current)
    }
}



