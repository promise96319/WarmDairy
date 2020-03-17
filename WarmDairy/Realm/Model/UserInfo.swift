//
//  UserInfo.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

/// 用户信息，只有一个用户，记录其偏好
class UserInfo: Object {
    @objc dynamic var id = 0
    /// 头像
    @objc dynamic var avatar: CreamAsset?
    /// 名称
    @objc dynamic var name = "Warm Dairy"
    /// 描述：格言等
    @objc dynamic var motto = "Good good study, day day up!"
    /// 密码
    @objc dynamic var password = ""
    
    @objc dynamic var isDeleted = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension UserInfo: CKRecordRecoverable {
    
}

extension UserInfo: CKRecordConvertible {
    
}

