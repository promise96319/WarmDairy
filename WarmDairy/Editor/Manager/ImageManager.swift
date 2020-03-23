//
//  File.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/13.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
/**
    图片管理器
    将图片保存至 cache/editor/images 中
 
    1. 当用户上传日记的时候，将 html 字符串中 img 替换成 tmp 目录 + 唯一的文件名称。并将文件名称数组存储起来。Realm + iCloud
    2. 访问日记的时候（详情时），现判断文件数组中的img在本地是否存在，如果不存在，则将文件存储到本地。如果存在，则继续，将文件 copy 到tmp文件中，以便在HTML中显示
    3. 期间，如果备份失败，需要做相应提示。todo
     4. 图片搜索路径： tmp 目录 -> document 目录 -> iCloud
 
 */
class ImageManager {
    static func removeImage(url: URL) -> Bool {
        return true
    }
}

