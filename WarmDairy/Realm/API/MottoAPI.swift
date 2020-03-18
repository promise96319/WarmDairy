//
//  MottoAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyUserDefaults

class MottoAPI {
    static func getMottos(callback: @escaping(_ data: [MottoModel]) -> Void) {
        let realm = try! Realm()
        let res: [MottoModel] = realm.objects(MottoModel.self).sorted(byKeyPath: "id", ascending: true).map { $0 }
        callback(res)
    }
    
    /// 添加motto
    /// - Parameters:
    ///   - date: motto的日期
    ///   - callback:
    /// 1. 搜索是否存在motto
    /// 2. 如果没有motto，则创建motto
        /// 2.1 如果是今天的motto，则用本地motto创建，并删除本地motto
        /// 2.2 如果不是今天的，则随机创建一个
    static func addMotto(date: Date, callback: @escaping(_ isAdded: Bool) -> Void) {
        let realm = try! Realm()
        let id = Int(date.toFormat("yyyyMMdd"))!
        let res = realm.objects(MottoModel.self).filter("id = \(id)")
        print("测试 ===> res的值为: \(res)")
        if res.count > 0 {
            callback(true)
            return
        }
        
        let motto = MottoModel()
        motto.id = id
        motto.date = date
        if date.compare(.isToday) {
            motto.imageURL = Defaults[.todayMottoImage]
            motto.motto = Defaults[.todayMotto]
            motto.author = Defaults[.todayMottoAuthor]
            Defaults[.todayMottoImage] = ""
            Defaults[.todayMotto] = ""
            Defaults[.todayMottoAuthor] = ""
            
            try! realm.write {
                realm.add(motto)
            }
            callback(true)
        } else {
            let randomMotto = generateRandomMotto()
            motto.imageURL = randomMotto.0
            motto.motto = randomMotto.1
            motto.author = randomMotto.2
            try! realm.write {
                realm.add(motto)
            }
            callback(true)
        }
    }
    
    static func generateRandomMotto() -> (String, String, String) {
        let randomIndex = Int.random(in: 0..<mottos.count)
        return mottos[randomIndex]
    }
    
    /// mottos 数组：[(image, motto, author)...]
    static let mottos = [
        ("https://app.dairy.qinguanghui.com/tea-time-3240766_1920.jpg", "没有被听见不是沉默的理由", "作家，雨果"),
        ("https://app.dairy.qinguanghui.com/reading-925589_1920.jpg", "幸福就是一双鞋合不合适只有自己一个人知道", "作家，大仲马"),
        ("https://app.dairy.qinguanghui.com/paper-1100254_1920.jpg", "今夜我不关心人类，我只想你", "诗人，海子"),
        ("https://app.dairy.qinguanghui.com/open-book-1428428_1920.jpg", "家人闲坐，灯火可亲", "冬天，汪曾祺"),
        ("https://app.dairy.qinguanghui.com/morning-2264051.jpg", "你再不来，我要下雪了", "木心"),
        ("https://app.dairy.qinguanghui.com/landscape-1732651_1920.jpg", "花褪残红青杏小，燕子飞时，绿水人家绕", "苏轼")
    ]
}

