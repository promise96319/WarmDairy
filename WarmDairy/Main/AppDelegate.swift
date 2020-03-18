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
        
        // 同步 iCloud
        syncEngine = SyncEngine(objects: [
            SyncObject<MottoModel>(),
            SyncObject<DairyModel>(),
            SyncObject<DairyImageModel>(),
            SyncObject<UserInfo>(),
        ], databaseScope: .private, container: CKContainer(identifier: "iCloud.com.GuanghuiQin.WarmDairy"))
        
        application.registerForRemoteNotifications()
        
        setUserDefault()
        
        window = UIWindow(frame: UIScreen.main.bounds)
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
}


