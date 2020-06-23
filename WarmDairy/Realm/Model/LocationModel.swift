//
//  File.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import RealmSwift

class LocationModel: Object {
    @objc dynamic var id: Int = IDTool.generateID()
    
    /// 经度 CLLocationDegrees -> CGFloat
    @objc dynamic var latitude: CGFloat = 0
    /// 纬度 CLLocationDegrees -> CGFloat
    @objc dynamic var longitude: CGFloat = 0
    /// 准确地址 或者 是用户自定义位置
    @objc dynamic var address: String = ""
    /// 位置别名
    @objc dynamic var name: String = ""
    
    @objc dynamic var isDeleted: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension LocationModel: CKRecordRecoverable {
    
}

extension LocationModel: CKRecordConvertible {
    
}
