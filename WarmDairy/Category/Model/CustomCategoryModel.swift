//
//  CustomCategoryModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class CustomCategoryModel {
    /// id，用于编辑和删除
    var id: Int = 0
    var image: String = ""
    var name: String = ""
    var dairies: [DairyModel] = [DairyModel]()
}
