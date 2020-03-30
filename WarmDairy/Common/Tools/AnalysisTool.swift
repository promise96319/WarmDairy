//
//  AnalysisTool.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/27.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import Firebase

class AnalysisTool {
    static let shared = AnalysisTool()
    private init() {}
    
    /// todo 更改是否记录事件
    var isDebuging: Bool = false
}

extension AnalysisTool {
    func logEvent(event: String) {
        if isDebuging { return }
        Analytics.logEvent(event, parameters: nil)
    }
}
