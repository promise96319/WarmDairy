//
//  ReminderNotificationManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/6/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import UserNotifications

/// 提醒通知标识符
enum NotificationsIdentifiers: String {
    case writeDiary = "writeDiary"
}

// MARK: - 通知类：授权，设置，添加通知，删除通知等
class ReminderNotificationManager {
    static let share = ReminderNotificationManager()
    private init() {}
    
    /// 提示文本后半部分内容
    let title = "写日记啦~(*^▽^*)"
    let contentBody = "今天有什么有意义的事情吗？来写下来吧！"
    
    var center = UNUserNotificationCenter.current()
    
    /// 获取授权状态
    func getAuthorizationStatus(callback: @escaping (_ status: UNAuthorizationStatus) -> Void){
        center.getNotificationSettings { settings in
            callback(settings.authorizationStatus)
        }
    }
    
    /// 提醒通知授权，返回是否授权
    func authorization(callback: @escaping (_ success: Bool) -> Void) {
        center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            callback(granted)
        }
    }
    
    /// 请求 reminder 提醒授权
    ///
    /// - Parameter callback: 授权成功的回调 -> 不成功则会跳转到设置界面
    func authorization(isRedirect: Bool = true, callback: @escaping () -> Void) {
        center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .carPlay, .badge]) { [weak self] (granted, error) in
            if granted {
                callback()
            } else {
                if isRedirect {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                        self?.redirectToSettings() { _ in }
                    })
                }
            }
        }
    }
    
    /// 跳转到设置界面进行设置
    func redirectToSettings(callback: @escaping (_ suceess: Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            if #available(iOS 10, *) {
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],
                                          completionHandler: {
                                            (success) in
                                            callback(success)
                })
            } else {
                UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                
            }
        })
    }
    
    /// 添加入睡的通知（另外自动添加起床的通知）
    ///
    /// - Parameters:
    ///   - hour:   定时的小时
    ///   - minute: 定时的分钟
    func addNotification(hour: Int, minute: Int) {
        if #available(iOS 10.0, *) {
            
            removeNotification()
            
            let content = UNMutableNotificationContent()
            
            content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: contentBody,
                                                                    arguments: nil)
            
            var dateInfo = DateComponents()
            dateInfo.hour = hour
            dateInfo.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            
            let request = UNNotificationRequest(identifier: NotificationsIdentifiers.writeDiary.rawValue, content: content, trigger: trigger)
            
            center.add(request) { (error : Error?) in
                if let theError = error {
                    CLog(theError.localizedDescription)
                }
            }
        } else {
            CLog("系统版本过低，无法发送通知。")
        }
    }
    
    /// 移除所有通知
    func removeNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [NotificationsIdentifiers.writeDiary.rawValue, NotificationsIdentifiers.writeDiary.rawValue])
    }
}

