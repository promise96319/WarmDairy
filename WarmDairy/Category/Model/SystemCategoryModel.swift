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
    var image: String = MottoAPI.generateRandomMotto().0
    var month: Int = -1
    var dairies: [DairyModel] = [DairyModel]()
}
