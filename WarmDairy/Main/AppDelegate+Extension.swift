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
        let today = Date().toFormat("yyyy MM dd")
        if Defaults[.lastActiveDate] != today && Defaults[.todayMottoImage] == "" {
            let motto = MottoAPI.generateRandomMotto()
            Defaults[.todayMottoImage] = motto.0
            Defaults[.todayMotto] = motto.1
            Defaults[.todayMottoAuthor] = motto.2
            Defaults[.lastActiveDate] = today
        }
    }
}
