//
//  DairyImageAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import RealmSwift
//图片逻辑
//    - 用户上传图片，保存到 tmp 目录，返回path加入到HTML中。
//    - 1. 用户保存日记的时候，解析html，从中取出图片路径。
//      2. 然后将图片上传到iCloud/Realm,
//        并且返回唯一的文件名称，保存到日记字段中。
//      3. 当图片完全上传的时候，上传日记。
//    - 取图片的时候，每当请求日记详情。根据图片唯一名称
//        1. 在tmp文件中取
//        2. 在document（iCloud不存在，realm中）中取，cope到tmp文件中。
//        3. 在iCloud中取（不是该设备的情况），cope到document，cope到tmp 中
class DairyImageAPI {
    static let imagePath = "editor/images"
    static let prefix = "QinGuanghuiWarmDairy"
    enum PathType {
        case doc
        case tmp
    }
    
    static func saveImage(image: UIImage?, callback: @escaping (_ path: String?) -> Void) {
        let dairyImage = DairyImageModel()
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            dairyImage.image = CreamAsset.create(object: dairyImage, propName: DairyImageModel.key, data: imageData)
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(dairyImage)
            }
            callback(dairyImage.image?.filePath.path)
        } else {
            callback(nil)
        }
    }
    
    /// 保存临时图片到 iCloud + document
    /// - Parameters:
    ///   - path: 临时图片路径
    ///   - callback: 该图片id
    static func saveImage(path: String, callback: @escaping (_ path: Int?) -> Void) {
        let dairyImage = DairyImageModel()
        dairyImage.image = CreamAsset.create(object: dairyImage, propName: DairyImageModel.key, url: URL(fileURLWithPath: path))
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(dairyImage)
        }
        
        let documentPath = gengeratePath(type: .doc, id: dairyImage.id)
        // 将图片copy到document当中
        if copeImage(fromPath: path, dirType: .doc, toPath: documentPath) {
            callback(dairyImage.id)
        }
        callback(nil)
    }
    
    static func getImage(id: Int, callback: @escaping(_ data: DairyImageModel?) -> Void) {
        let realm = try! Realm()
        let res: DairyImageModel? = realm.objects(DairyImageModel.self).filter("id = \(id)").first
        callback(res)
    }
    
    /// 删除 图片
    /// - Parameter id: 图片id
    static func deleteImage(id: Int) {
        let realm = try! Realm()
        let res = realm.objects(DairyImageModel.self).filter("id = \(id)")
        if res.count > 0 {
            /// 说明有数据，那么更新
            try! realm.write {
                realm.create(DairyImageModel.self, value: ["id": id, "isDeleted": true], update: .modified)
                print("测试 ====> 删除图片完毕")
            }
        }
    }
}

extension DairyImageAPI {
    /// 检验文件是否存在，存在
    /// - Parameters:
    ///   - images: 图片唯一id：字符串，"id1,id2,..."
    ///   - html: 需要被替换的HTML字符串
    ///   - callback: 新的HTML字符串
    static func replaceHtmlWithImagePath(images: String, html: String, callback: @escaping (_ result: String?) -> Void) {
        let imageIds = images.split(separator: ",")
        var newHtml = html
        for id in imageIds {
            // 首先在tmp中查找图片，查找到则返回路径
            // 根据id找到图片得到图片document 路径
            // 查看document 是否存在，存在则copy到tmp中
            // 否则 将 data 写入 document 和 tmp中
            CLog("Int(String(id))的值为: \(Int(String(id)))")
            guard let id = Int(String(id)) else {
                CLog("测试 ===> id不存在")
                callback(nil)
                return
            }
            CLog("id存在的值为: \(id)")
            let fileId = "\(prefix)\(id)"
            // 现在 tmp 目录中查找一遍
            let tmpPath = gengeratePath(type: .tmp, id: id)
            let docPath = gengeratePath(type: .doc, id: id)
            CLog("tmpPath: \(tmpPath)")
            if (FileManager.fileExists(atPath: tmpPath)) {
                newHtml = newHtml.replacingOccurrences(of: fileId, with: tmpPath)
                print("测试 ====> tmp 中存在image")
            } else if (FileManager.fileExists(atPath: docPath)) {
                print("测试 ====> document 中存在image")
                if copeImage(fromPath: docPath, dirType: .tmp, toPath: tmpPath) {
                    newHtml = newHtml.replacingOccurrences(of: fileId, with: tmpPath)
                    print("测试 ====> newHtml\(newHtml)")
                } else {
                    print("测试 ===> copy image 失败")
                }
            } else {
                print("测试 ===> doc,tmp均不存在图片")
                MessageTool.shared.showMessage(title: "正在同步数据，请耐心等待...")
                getImage(id: id) { (asset) in
                    guard let asset = asset else {
                        print("测试 ===> image不存在")
                        callback(nil)
                        return
                    }
                    
                    guard let data = asset.image?.storedData() else {
                        print("测试 ====> image stored data 不存在")
                        callback(nil)
                        return
                    }
                    
                    let isSaved = FileManager.save(image: UIImage(data: data)!, toFilePath: docPath)
                    print("测试 ===> isSaved的值为: \(isSaved)")
                    let isTmpSaved = FileManager.save(image: UIImage(data: data)!, toFilePath: tmpPath)
                    print("测试 ===> isTmpSaved的值为: \(isTmpSaved)")
                    if isSaved && isTmpSaved {
                        print("测试 ===> icloud copy 到本地了")
                        newHtml = newHtml.replacingOccurrences(of: fileId, with: tmpPath)
                    } else {
                        print("测试 ====> iclcoud copy 失败")
                        callback(nil)
                    }
                }
            }
        }
        callback(newHtml)
    }
    
    // 保存上传的图片到 tmp 目录中
    // 返回tmp 内文件路径
    static func saveImageToTmp(image: UIImage) -> String? {
        let directory = FileManager.tmpPath + DairyImageAPI.imagePath
        if !FileManager.fileExists(atPath: directory) {
            if !FileManager.createDirectory(atPath: directory) {
                return nil
            }
        }
        
        let path = directory + "/" + prefix + String(IDTool.generateID())
        if FileManager.save(image: image, toFilePath: path) {
            return path
        }
        
        return nil
    }
    
    static func copeImage(fromPath: String, dirType: PathType, toPath: String) -> Bool {
        let dir = gengerateDir(type: dirType)
        if !FileManager.fileExists(atPath: dir) {
            let isCreated = FileManager.createDirectory(atPath: dir)
            if (!isCreated) { return false }
        }
        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
            return true
        } catch (_) {
            return false
        }
    }
    
    static func gengeratePath(type: PathType, id: Int) -> String {
        let dir = gengerateDir(type: type)
        if !FileManager.fileExists(atPath: dir) {
            let isCreated = FileManager.createDirectory(atPath: dir)
            if !isCreated {
                CLog("创建目录失败")
            }
        }
        return dir + "/" + prefix + "\(id)"
    }
    
    static func gengerateDir(type: PathType) -> String {
        switch type {
        case .doc:
            return FileManager.documentPath + "/" + imagePath
        case .tmp:
            return FileManager.tmpPath + imagePath
        }
    }
}
