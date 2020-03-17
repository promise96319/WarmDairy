//
//  IDTool.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/14.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class IDTool {
    static func generateID() -> Int {
        let date = Int(Date().timeIntervalSince1970 * 1000)
        let random = Int.random(in: 10...99)
        return date * 100 + random
    }
}
