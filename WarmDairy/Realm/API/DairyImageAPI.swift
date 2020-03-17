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
    static let prefix = "silence_"
    
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
    
    static func saveImage(path: String, callback: @escaping (_ path: String?) -> Void) {
        let dairyImage = DairyImageModel()
        dairyImage.image = CreamAsset.create(object: dairyImage, propName: DairyImageModel.key, url: URL(fileURLWithPath: path))
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(dairyImage)
        }
        
        callback(dairyImage.image?.uniqueFileName)
    }
    
    static func getImage(callback: @escaping(_ data: [DairyImageModel]) -> Void) {
        let realm = try! Realm()
        let res: [DairyImageModel] = realm.objects(DairyImageModel.self).map { $0 }
        callback(res)
    }
}

extension DairyImageAPI {
    // 保存上传的图片到 tmp 目录中
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
    
    //    static func saveHTMLToTmp(string: String) -> String? {
    //        let directory = FileManager.cachePath + "index.html"
    //        if !FileManager.fileExists(atPath: directory) {
    //            if !FileManager.createDirectory(atPath: directory) {
    //                return nil
    //            }
    //        }
    //
    //        let path = directory
    //        if FileManager.save(info: string, toFilePath: path) {
    //            return path
    //        }
    //
    //        return nil
    //    }
    //
    //    static func getHTML() -> String {
    //        return FileManager.cachePath + "index.html"
    //    }
}
