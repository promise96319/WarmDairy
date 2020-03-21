//
//  DairyModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/14.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import RealmSwift

class DairyModel: Object {
    @objc dynamic var id: Int = IDTool.generateID()
    
    /// 标题
    @objc dynamic var title: String = ""
    
    /// HTML string 内容
    @objc dynamic var content: String = ""
    
    /// 创建日期
    @objc dynamic var createdAt: Date = Date()
    
    /// 心情
    @objc dynamic var mood: String = ""
    
    /// 天气
    @objc dynamic var weather: String = ""
    
    /// 位置
    @objc dynamic var location: String = ""
    
    /// 日记背景颜色
    @objc dynamic var bgColor: String = "EEDFC8"
    
    /// 是否加入喜爱
    @objc dynamic var isLoved: Bool = false
    
    /// id 组成的字符串，用于判断日记属于那些分类
    @objc dynamic var cateIds: String = ""
    
    /// 是否加锁
    @objc dynamic var isLocked: Bool = false
    
    /// 日记中使用到的图片（逗号分隔）： "图片名称,图片名称2"
    @objc dynamic var images: String = ""
    
    @objc dynamic var isDeleted = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension DairyModel: CKRecordConvertible {}

extension DairyModel: CKRecordRecoverable {}
