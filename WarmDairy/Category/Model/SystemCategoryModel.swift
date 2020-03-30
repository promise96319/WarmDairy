//
//  SystemCategoryModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class CategoryYearModel {
    var year: Int = -1
    var months: [CategoryMonthModel] = [CategoryMonthModel]()
}

class CategoryMonthModel {
    /// 如果 diary 中存在 locked 则需要验证才能打开
    var isLocked: Bool = false
    var image: String = MottoAPI.generateRandomMotto().0
    var month: Int = -1
    var dairies: [DairyModel] = [DairyModel]()
}
