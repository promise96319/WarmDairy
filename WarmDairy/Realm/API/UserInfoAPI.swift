//
//  UserInfoAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyUserDefaults

class UserInfoAPI {
    static let userID = 1314520
    
    static func getUser(callback: @escaping(_ data: UserInfo) -> Void) {
        let realm = try! Realm()
        let res: [UserInfo] = realm.objects(UserInfo.self).map { $0 }
        
        /// 获取用户，如果没有，则创建一个用户，保存到数据库中。
        if res.count == 0 {
            let userinfo = UserInfo()
            userinfo.avatar = CreamAsset.create(object: userinfo, propName: UserInfo.avatarKey, url: URL(string: "https://app.dairy.qinguanghui.com/avatar.jpg")!)
            
            try! realm.write {
                realm.add(userinfo)
            }
            callback(userinfo)
            return
        }
        
        callback(res.first!)
    }
    
    static func saveUserInfo(userInfo: [String: Any], isNotify: Bool = true) {
        var newInfo = userInfo
        newInfo["id"] = userID
        let realm = try! Realm()
        try! realm.write {
            realm.create(UserInfo.self, value: newInfo, update: .modified)
            if isNotify {
                NotificationCenter.default.post(name: .userInfoDidChanged, object: nil)
            }
        }
    }
    
    /// 记录活跃天数
    static func recordActiveDay() {
        CLog("Defaults[.lastActiveDay]的值为: \(Defaults[.lastActiveDay])")
        if (Defaults[.lastActiveDay] == Date().toFormat("yyyy-MM-dd")) {
            return
        }
        getUser { (userinfo) in
            CLog("userinfo的值为: \(userinfo)")
            let realm = try! Realm()
            try! realm.write {
                realm.create(UserInfo.self, value: ["id": userinfo.id, "continuousCreation": userinfo.continuousCreation + 1], update: .modified)
                Defaults[.lastActiveDay] = Date().toFormat("yyyy-MM-dd")
                NotificationCenter.default.post(name: .userInfoDidChanged, object: nil)
            }
        }
    }
    
    /// 记录编辑时间
    static func saveRecordTime(minutes: Int) {
        getUser { (userinfo) in
            let realm = try! Realm()
            try! realm.write {
                realm.create(UserInfo.self, value: ["id": userinfo.id, "recordTime": userinfo.recordTime + 1], update: .modified)
                NotificationCenter.default.post(name: .userInfoDidChanged, object: nil)
            }
        }
    }
}
