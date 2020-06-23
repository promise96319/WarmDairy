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
    @objc dynamic var id = UserInfoAPI.userID
    static let avatarKey = "user_avatar"
    /// 头像
    @objc dynamic var avatar: CreamAsset?
    /// 名称
    @objc dynamic var name = "Silence"
    /// 描述：格言等
    @objc dynamic var motto = "满地都是六便士，他却抬头看见了月亮🌙"
    /// 密码
    @objc dynamic var password = ""
    /// 记录时长
    @objc dynamic var recordTime: Int = 0
    /// 连续创作天数
    @objc dynamic var continuousCreation: Int = 0
    /// 是否使用锁屏密码
    @objc dynamic var isLaunchPasswordEnable: Bool = false
    
    @objc dynamic var isDeleted = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension UserInfo: CKRecordRecoverable {
    
}

extension UserInfo: CKRecordConvertible {
    
}

