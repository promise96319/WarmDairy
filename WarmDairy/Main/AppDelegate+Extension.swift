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
import Kingfisher

extension AppDelegate {
    func configImageCache() {
        let cache = ImageCache.default
        /// 最多缓存100M
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        /// 最大缓存100张
        cache.memoryStorage.config.countLimit = 100
        /// 三分钟后过期
        cache.memoryStorage.config.expiration = .seconds(3 * 60)
    }
    
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
        /// 如果是第一次进入APP， 默认照片质量中等
        /// 为用户创建一个默认为「喜爱」的分类
        if Defaults[.lastActiveDay] == "" {
            Defaults[.imageQuality] = 1
            
            CategoryAPI.getCategories { (categories) in
                /// 第一次进入且不存在 category, 则创建4个默认分类
                if categories.count == 0 {
                    CategoryAPI.addCategory(id: 0, name: "奇思妙想", image: "https://app.dairy.qinguanghui.com/16_night-photograph-2183637_1920%20%281%29.jpg", isNotify: false) { _ in }
                    CategoryAPI.addCategory(id: 1, name: "旅行记", image: "https://app.dairy.qinguanghui.com/46.keegan-houser--Q_t4SCN8c4-unsplash.jpg", isNotify: false) { _ in }
                    CategoryAPI.addCategory(id: 2, name: "成长记", image: "https://app.dairy.qinguanghui.com/35_narrative-794978_1920.jpg", isNotify: false) { _ in }
                    CategoryAPI.addCategory(id: 3, name: "恋爱记", image: "https://app.dairy.qinguanghui.com/48_filipe-almeida-hQuQwfY8QoE-unsplash.jpg", isNotify: false) { _ in }
                }
            }
            
            LocationAPI.getLocations { (locations) in
                if locations.count == 0 {
                    let beijing = LocationModel()
                    beijing.id = 0
                    beijing.latitude = 39.90403
                    beijing.longitude = 116.407526
                    beijing.address = "北京"
                    beijing.name = "北京"
                    
                    let shanghai = LocationModel()
                    shanghai.id = 1
                    shanghai.latitude = 31.230416
                    shanghai.longitude = 121.473701
                    shanghai.address = "上海"
                    shanghai.name = "上海"
                    
                    let guangzhou = LocationModel()
                    guangzhou.id = 2
                    guangzhou.latitude = 23.129162
                    guangzhou.longitude = 113.264434
                    guangzhou.address = "广州"
                    guangzhou.name = "广州"
                    
                    LocationAPI.saveLocations(location: beijing, isNotify: false) { _ in }
                    LocationAPI.saveLocations(location: shanghai, isNotify: false) { _ in }
                    LocationAPI.saveLocations(location: guangzhou, isNotify: false) { _ in }
                }
            }
            
            DairyAPI.getDairy { (diaries) in
                if diaries.count == 0 {
                    let diary = DairyModel()
                    diary.id = 0
                    diary.title = "^_^"
                    diary.content = "从今天起，可以安安静静的写日记了！"
                    diary.weather = Weathers.sun.rawValue
                    diary.mood = Moods.all[0].image
                    DairyAPI.addDairy(dairy: diary) { _ in }
                }
            }
        }
        
        UserInfoAPI.recordActiveDay()
        
        if (Defaults[.reminderHour] == 0 && Defaults[.reminderMinute] == 0) {
            Defaults[.reminderHour] = 21
            Defaults[.reminderMinute] = 0
        }
    }
}
