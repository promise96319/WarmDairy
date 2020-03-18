//
//  File.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

extension Int {
    func toWeek() -> String {
        /// 常量 星期的数组，数组 index==0 空出来
        let WEEKS = ["", "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        if (self > 0 && self < 8) {
             return WEEKS[self]
        }
        return "\(self)"
    }
}



