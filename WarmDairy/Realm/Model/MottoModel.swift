//
//  MottoModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class MottoModel: Object {
    // id: 用年月日表示即可 一天只有一个motto，所以创建日期独一无二
    @objc dynamic var id: Int = 20200101
    // 日期
    @objc dynamic var createDate: Date?
    // 当日图片
    @objc dynamic var imageURL: String = ""
    // 当日格言
    @objc dynamic var motto: String = ""
    // 格言作者
    @objc dynamic var author: String = ""
    
    let dairies = LinkingObjects(fromType: DairyModel.self, property: "createdAt")
    
    @objc dynamic var isDeleted: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension MottoModel: CKRecordRecoverable {
    
}

extension MottoModel: CKRecordConvertible {
    
}
