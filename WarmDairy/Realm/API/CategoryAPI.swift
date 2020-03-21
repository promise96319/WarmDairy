//
//  CategoryAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryAPI {
    static func getCategories(callback: @escaping(_ data: [CategoryModel]) -> Void) {
        let realm = try! Realm()
        let res: [CategoryModel] = realm.objects(CategoryModel.self).map { $0 }
        callback(res)
    }
    
    static func getCategoriesWithDairies(callback: @escaping(_ data: [CustomCategoryModel]) -> Void) {
        let realm = try! Realm()
        let res: [CategoryModel] = realm.objects(CategoryModel.self).map { $0 }
        var datas = [CustomCategoryModel]()
        for cate in res {
            DairyAPI.getDairy(cateId: cate.id) { (dairies) in
                let cateModel = CustomCategoryModel()
                cateModel.id = cate.id
                cateModel.image = cate.image
                cateModel.name = cate.name
                cateModel.dairies = dairies
                datas.append(cateModel)
            }
        }
        callback(datas)
    }
    
    static func addCategory(name: String, callback: @escaping(_ isAdd: Bool) -> Void) {
        let cate = CategoryModel()
        cate.name = name
        let realm = try! Realm()
        try! realm.write {
            realm.add(cate)
        }
        callback(true)
    }
    
    static func updateCategory(id: Int, name: String, callback: @escaping(_ isUpdated: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(CategoryModel.self, value: ["id": id, "name": name], update: .modified)
        }
        callback(true)
    }
    
    static func removeCategory(id: Int, callback: @escaping(_ isDeleted: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(CategoryModel.self, value: ["id": id, "isDeleted": true], update: .modified)
        }
        callback(true)
    }
}
