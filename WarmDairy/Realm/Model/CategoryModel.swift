//
//  CategoryModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object {
    @objc dynamic var id: Int = IDTool.generateID()
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var image: String = MottoAPI.generateRandomMotto().0
    
    @objc dynamic var isDeleted: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension CategoryModel: CKRecordRecoverable {
    
}

extension CategoryModel: CKRecordConvertible {
    
}
