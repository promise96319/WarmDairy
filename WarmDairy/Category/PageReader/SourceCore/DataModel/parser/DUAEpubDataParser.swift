//
//  DUAEpubDataParser.swift
//  DUAReader
//
//  Created by mengminduan on 2017/12/27.
//  Copyright © 2017年 nothot. All rights reserved.
//

import UIKit
import DTCoreText

class DUAEpubDataParser: DUADataParser {
    
    /// 将所有日记分成章节形式
    /// - Parameters:
    ///   - dairies: 所有日记
    ///   - completeHandler: 返回  章节标题数组，章节内容数组
    override func parseChapterFromBook(dairies: [DairyModel], completeHandler: @escaping (Array<String>, Array<DUAChapterModel>) -> Void) {
        
        // 1. 日记排序，从旧到新
        var newDairies = dairies
        newDairies.sort(by: { $0.createdAt < $1.createdAt })
        // 2. 分成章节
        
        /// 章节名称：也是日记的日期
        var titleArray: [String] = []
        /// 每一天的日记（需要将title添加进去）
        var models: [DUAChapterModel] = []
        /// 遍历日记，添加到章节
        for (index, dairy) in dairies.enumerated() {
            let title = dairy.title == "" ? "暂无标题" : dairy.title
            titleArray.append(title)
            
            let chapter = DUAChapterModel()
            chapter.title = title
            chapter.date = dairy.createdAt
            chapter.weather = dairy.weather
            chapter.mood = dairy.mood
            chapter.title = dairy.title
            chapter.content = "<h1>\(dairy.title)</h1>" + dairy.content
            chapter.chapterIndex = index + 1
            models.append(chapter)
        }
        
        completeHandler(titleArray, models)
    }
    
    /// 将章节HTML内容转化成 NSAttributeString
    /// - Parameters:
    ///   - chapter: 章节
    ///   - config: 内容配置
    override func attributedStringFromChapterModel(chapter: DUAChapterModel, config: DUAConfiguration) -> NSAttributedString? {
        let start = "<!DOCTYPE html><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no\"><meta charset=\"UTF-8\"><style media=\"screen\">img { display: block; text-align: center; padding: 8px; margin: 0px;} h1 {font-size: 28px; font-weight: 700;}</style></head><body>"
        let end = "</body>"
        let str = start + chapter.content + end
        CLog("测试 ===> str的值为: \(str)")
        
        let htmlData = Data(str.utf8)
        
        let options = [
            DTDefaultFontFamily : "Times New Roman",
            DTDefaultLinkColor  : "purple",
            NSTextSizeMultiplierDocumentOption : 1.0,
            DTDefaultFontSize   : config.fontSize,
            DTDefaultLineHeightMultiplier : config.lineHeightMutiplier,
            DTDefaultTextAlignment : "0",
            DTDefaultHeadIndent : "0.0",
            NSBaseURLDocumentOption : URL(fileURLWithPath: FileManager.tmpPath + DairyImageAPI.imagePath),
            DTMaxImageSize      : config.contentFrame.size,
            ] as [String : Any]
        let attrString: NSAttributedString? = NSAttributedString.init(htmlData: htmlData, options: options, documentAttributes: nil)
        return attrString
    }
}
