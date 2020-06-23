//
//  AppDelegate.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/5.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var syncEngine: SyncEngine?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// 配置图片缓存
        configImageCache()
        
        /// 配置 firebase
        configFirebase()
        
        /// 配置 时间时区
        configDefaultRegion()
        
        /// 完成交易
        completeTransaction()
        
        /// 配置 iCloud 同步
        configRealm()
        // 同步 iCloud
        syncEngine = SyncEngine(objects: [
            SyncObject<MottoModel>(),
            SyncObject<DairyModel>(),
            SyncObject<DairyImageModel>(),
            SyncObject<UserInfo>(),
            SyncObject<CategoryModel>(),
            SyncObject<LocationModel>(),
        ], databaseScope: .private, container: CKContainer(identifier: "iCloud.com.GuanghuiQin.WarmDairy"))
        application.registerForRemoteNotifications()
        
        /// 配置 默认值
        configUserDefault()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(hexString: "F1F6FA")
        window?.makeKeyAndVisible()
        
        window?.rootViewController = TabBarViewController()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let dict = userInfo as? [String: NSObject], let notification = CKNotification(fromRemoteNotificationDictionary: dict), let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            completionHandler(.newData)
        }

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // How about fetching changes here?
    }
    
    // 进入前台
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ApplicationDidBecomeActive"), object: nil)
    }
}


