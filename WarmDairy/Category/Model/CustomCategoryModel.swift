//
//  CustomCategoryModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class CustomCategoryModel {
    /// 如果 diary 中存在 locked 则需要验证才能打开
    var isLocked: Bool = false
    /// id，用于编辑和删除
    var id: Int = 0
    var image: String = ""
    var name: String = ""
    var dairies: [DairyModel] = [DairyModel]()
}
