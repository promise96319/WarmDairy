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
        var res: [CategoryModel] = realm.objects(CategoryModel.self).filter("isDeleted = false").map { $0 }
        res = res.sorted(by: { $0.id > $1.id })
        callback(res)
    }
    
    static func getCategoriesWithDairies(callback: @escaping(_ data: [CustomCategoryModel]) -> Void) {
        let realm = try! Realm()
        let res: [CategoryModel] = realm.objects(CategoryModel.self).filter("isDeleted = false").map { $0 }
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
        datas = datas.sorted(by: {  $0.id > $1.id })
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
        NotificationCenter.default.post(name: .categoryDidChanged, object: nil)
        MessageTool.shared.showMessage(title: "添加成功！")
    }
    
    static func updateCategory(id: Int, name: String, callback: @escaping(_ isUpdated: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(CategoryModel.self, value: ["id": id, "name": name], update: .modified)
        }
        callback(true)
        NotificationCenter.default.post(name: .categoryDidChanged, object: nil)
        MessageTool.shared.showMessage(title: "编辑成功！")
    }
    
    static func removeCategory(id: Int, callback: @escaping(_ isDeleted: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(CategoryModel.self, value: ["id": id, "isDeleted": true], update: .modified)
        }
        callback(true)
        NotificationCenter.default.post(name: .categoryDidChanged, object: nil)
        MessageTool.shared.showMessage(title: "删除成功！")
    }
}
