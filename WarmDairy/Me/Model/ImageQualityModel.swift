//
//  ImageQualityModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/29.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

enum ImageQuality: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case superHigh = "superHigh"
    
    static let all: [ImageQualityModel] = [
        ImageQualityModel(id: ImageQuality.low.rawValue, size: 512, name: "低"),
        ImageQualityModel(id: ImageQuality.medium.rawValue, size: 1024, name: "中（推荐）"),
        ImageQualityModel(id: ImageQuality.high.rawValue, size: 1536, name: "高"),
        ImageQualityModel(id: ImageQuality.superHigh.rawValue, size: 2048, name: "超高"),
    ]
}

class ImageQualityModel {
    /// 比较的值 low | medium | high | 等
    var id: String = ""
    /// 大小 KB
    var size: Int = 500
    /// 替代名称
    var name: String = ""
    
    init(id: String = "", size: Int = 500, name: String = "") {
        self.id = id
        self.size = size
        self.name = name
    }
}
