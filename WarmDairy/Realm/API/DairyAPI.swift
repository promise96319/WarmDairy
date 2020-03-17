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
    
    static func addDairy(dairy: DairyModel, callback: @escaping(_ isAdded: Bool) -> Void) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(dairy)
        }
        
        callback(true)
    }
}
