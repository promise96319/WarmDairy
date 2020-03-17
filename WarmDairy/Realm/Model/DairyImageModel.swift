//
//  DairyImageModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class DairyImageModel: Object {
    @objc dynamic var id = IDTool.generateID()
    
    @objc dynamic var isDeleted = false
    
    static let key = "Dairy_Image.jpeg"
    @objc dynamic var image: CreamAsset?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension DairyImageModel: CKRecordRecoverable {
    
}

extension DairyImageModel: CKRecordConvertible {
    
}
