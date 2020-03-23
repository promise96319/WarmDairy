//
//  AppDelegate+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftDate
import RealmSwift

extension AppDelegate {
    /// Realm 数据库配置 - 数据库迁移
    func configRealm() {
        let config = Realm.Configuration(
            // 当前版本号， 默认版本为 0，每次迁移的时候需更新
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                // 数据迁移
                CLog("迁移1的值为: \(oldSchemaVersion)")
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: DairyModel.className()) { (oldObject, newObject) in
                        newObject!["cateIds"] = ""
                    }
                }
                CLog("迁移2的值为: \(oldSchemaVersion)")
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: UserInfo.className()) { (oldObject, newObject) in
                        newObject!["recordTime"] = 0
                        newObject!["continuousCreation"] = 0
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// 所用时间时区配置
    func configDefaultRegion() {
        SwiftDate.defaultRegion = .current
    }
    
    /// 默认数据配置
    func configUserDefault() {
        UserInfoAPI.recordActiveDay()
        Defaults[.isVIP] = false
    }
}
