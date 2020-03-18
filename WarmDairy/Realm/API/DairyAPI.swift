//
//  DairyAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/14.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class DairyAPI {
    static func getDairy(callback: @escaping(_ data: [DairyModel]) -> Void) {
        let realm = try! Realm()
        let res: [DairyModel] = realm.objects(DairyModel.self).map { $0 }
        callback(res)
    }
    
    static func getDairy(date: Date, callback: @escaping(_ data: [DairyModel]) -> Void) {
        let realm = try! Realm()
        let res: [DairyModel] = realm.objects(DairyModel.self).sorted(byKeyPath: "id").map { $0 }
        let filterRes = res.filter {
            return $0.createdAt.compare(toDate: date, granularity: .day) == .orderedSame
        }
        let replaceHtml = filterRes.map { (dairy) -> DairyModel in
            let newDairy = DairyModel()
            newDairy.id = dairy.id
            newDairy.createdAt = dairy.createdAt
            newDairy.title = dairy.title
            newDairy.content = dairy.content
            newDairy.images = dairy.images
            newDairy.isLoved = dairy.isLoved
            newDairy.isLocked = dairy.isLocked
            newDairy.isDeleted = dairy.isDeleted
            newDairy.weather = dairy.weather
            newDairy.location = dairy.location
            newDairy.mood = dairy.mood
            newDairy.bgColor = dairy.bgColor
            
            DairyImageAPI.replaceHtmlWithImagePath(images: newDairy.images, html: newDairy.content) { (newHtml) in
                if let newHtml = newHtml {
                    newDairy.content = newHtml
                }
            }
            return newDairy
        }
        callback(replaceHtml)
    }
    
    static func addDairy(dairy: DairyModel, callback: @escaping(_ isAdded: Bool) -> Void) {
        
        // 此时日记是没有问题的。添加格言
        MottoAPI.addMotto(date: dairy.createdAt) { isMottoAdded in
            if (isMottoAdded) {
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(dairy)
                }
                
                callback(true)
            } else {
                callback(false)
            }
        }
    }
}
