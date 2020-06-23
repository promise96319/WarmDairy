//
//  LocationAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class LocationAPI {
    
    static func getLocations(callback: @escaping ([LocationModel]) -> Void) {
        let realm = try! Realm()
        let res: [LocationModel] = realm.objects(LocationModel.self).filter("isDeleted=\(false)").sorted(byKeyPath: "id", ascending: false).map { $0 }
        callback(res)
    }
    
    static func getLocationsWithDairies(callback: @escaping(_ data: [CustomLocationModel]) -> Void) {
        let realm = try! Realm()
        let res: [LocationModel] = realm.objects(LocationModel.self).filter("isDeleted = false").sorted(byKeyPath: "id", ascending: false).map { $0 }
        var datas = [CustomLocationModel]()
        for location in res {
            DairyAPI.getDairy(locationId: location.id) { (dairies) in
                let locationModel = CustomLocationModel()
                locationModel.id = location.id
                locationModel.name = location.name
                locationModel.address = location.address
                locationModel.diaries = dairies
                datas.append(locationModel)
            }
        }
        callback(datas)
    }
    
    static func getLocation(diaryId: Int, callback: @escaping (LocationModel?) -> Void) {
        let realm = try! Realm()
        let res: [LocationModel] = realm.objects(LocationModel.self).filter("isDeleted=\(false) AND id = \(diaryId)").sorted(byKeyPath: "id", ascending: false).map { $0 }
        if res.count > 0 {
            callback(res[0])
        } else {
            callback(nil)
        }
    }
    
    static func saveLocations(location: LocationModel, isNotify: Bool = true, callback: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(LocationModel.self, value: location, update: .modified)
            if isNotify {
                NotificationCenter.default.post(name: .locationDidChanged, object: nil)
            }
        }
        callback(true)
    }
    
    static func deleteLocation(id: Int, callback: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(LocationModel.self, value: ["id": id, "isDeleted": true], update: .modified)
            NotificationCenter.default.post(name: .locationDidChanged, object: nil)
        }
        callback(true)
    }
}
