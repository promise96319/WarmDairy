//
//  AppDelegate+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftDate

extension AppDelegate {
    func setUserDefault() {
        // TODO: - 默认值
        SwiftDate.defaultRegion = .current
    }
}
