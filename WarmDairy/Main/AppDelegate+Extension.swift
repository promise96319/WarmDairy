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
import Firebase

extension AppDelegate {
    func configFirebase() {
        FirebaseApp.configure()
    }
    
    func completeTransaction() {
        IAPManager.shared.completeTransaction()
        
        if Defaults[.monthPrice] == "" {
            Defaults[.monthPrice] = "￥6"
        }
        if Defaults[.yearPrice] == "" {
            Defaults[.yearPrice] = "￥28"
        }
        if Defaults[.lifetimePrice] == "" {
            Defaults[.lifetimePrice] = "￥88"
        }
        var productsIDs = Set<String>()
        productsIDs.insert(IAPManager.ProductID.month)
        productsIDs.insert(IAPManager.ProductID.year)
        productsIDs.insert(IAPManager.ProductID.lifetime)
        IAPManager.shared.retrieveProductsInfo(productIDs: productsIDs) { (result) in
            if result.retrievedProducts.count > 0 {
                for product in result.retrievedProducts {
                    switch product.productIdentifier {
                    case IAPManager.ProductID.month:
                        if let price = product.localizedPrice {
                            Defaults[.monthPrice] = price
                        }
                    case IAPManager.ProductID.year:
                        if let price = product.localizedPrice {
                            Defaults[.yearPrice] = price
                        }
                    case IAPManager.ProductID.lifetime:
                        if let price = product.localizedPrice {
                            Defaults[.lifetimePrice] = price
                        }
                    default:
                        CLog("product.productIdentifier:\(product.productIdentifier)")
                        break
                    }
                }
            } else {
                CLog("请求商品ID失败")
            }
        }
        
        // 判断内购是否过期
        if Defaults[.isLifeTimeVIP] {
            CLog("终身会员")
            Defaults[.isVIP] = true
            return
        }
        
        CLog("订阅截止日期为:\(Date(timeIntervalSince1970: Defaults[.subscriptionExprireDate]).toFormat("yyyy MM dd HH:mm:ss")) ")
        CLog("现在时间的值为: \(Date().toFormat("yyyy MM dd HH:mm:ss"))")
        if Defaults[.subscriptionExprireDate] > Date().timeIntervalSince1970 {
            CLog("是VIP")
            Defaults[.isVIP] = true
        } else {
            CLog("不是VIP")
            Defaults[.isVIP] = false
        }
    }
    
    /// Realm 数据库配置 - 数据库迁移
    func configRealm() {
//        let config = Realm.Configuration(
//            // 当前版本号， 默认版本为 0，每次迁移的时候需更新
//            schemaVersion: 3,
//            migrationBlock: { migration, oldSchemaVersion in
//                // 数据迁移
//                CLog("迁移1的值为: \(oldSchemaVersion)")
//                if (oldSchemaVersion < 1) {
//                    migration.enumerateObjects(ofType: DairyModel.className()) { (oldObject, newObject) in
//                        newObject!["cateIds"] = ""
//                    }
//                }
//                CLog("迁移2的值为: \(oldSchemaVersion)")
//                if (oldSchemaVersion < 2) {
//                    migration.enumerateObjects(ofType: UserInfo.className()) { (oldObject, newObject) in
//                        newObject!["recordTime"] = 0
//                        newObject!["continuousCreation"] = 0
//                    }
//                }
//
//                if (oldSchemaVersion < 3) {
//                    migration.enumerateObjects(ofType: UserInfo.className()) { (oldObject, newObject) in
//                        newObject!["isLaunchPasswordEnable"] = false
//                    }
//                }
//        })
//
//        Realm.Configuration.defaultConfiguration = config
    }
    
    /// 所用时间时区配置
    func configDefaultRegion() {
        SwiftDate.defaultRegion = .current
    }
    
    /// 默认数据配置
    func configUserDefault() {
        UserInfoAPI.recordActiveDay()
        
        /// 如果是第一次进入APP， 默认照片质量中等
        if Defaults[.lastActiveDay] == "" {
            Defaults[.imageQuality] = 1
        }
    }
}
