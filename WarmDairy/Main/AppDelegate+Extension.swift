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
            // 默认版本为 0
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // 数据迁移
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: DairyModel.className()) { (oldObject, newObject) in
                        newObject!["cateIds"] = ""
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
        // TODO: - 默认值
    }
}
