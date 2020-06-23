//
//  ExportDiaryManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
import SwiftDate

class ExportDiaryControllerDelegate: UIViewController {
    var tmpWebview = WKWebView()
    
    lazy var exportDiaryManager = ExportDiaryManager()
    
    var hub: MBProgressHUD?
    
    var dairyType: ExportDiaryViewController.ExportType = .cate
    
    var filename = "Warm Diary"
    
    override func viewDidLoad() {
        _ = tmpWebview.then {
            $0.isHidden = true
            $0.navigationDelegate = self
            view.addSubview($0)
        }
        
        exportDiaryManager.delegate = self
    }
}

// MARK: - public method
extension ExportDiaryControllerDelegate {
    /// 暴露导出的方法
    public func exportDiariesToPDF(diaries: [DairyModel], type: ExportDiaryViewController.ExportType, filename: String, isNeedImagePathReplaced: Bool = true) {
        hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub?.label.text = "正在生成PDF..."
        hub?.mode = .indeterminate
        hub?.animationType = .fade
        hub?.show(animated: true)
        
        exportDiaryManager.loadDiaryToHtml(diaries: diaries, isNeedImagePathReplaced: isNeedImagePathReplaced)
        self.filename = filename
    }
}

extension ExportDiaryControllerDelegate: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { exportDiaryManager.exportHTMLContentToPDF(fileName: filename)
    }
}

extension ExportDiaryControllerDelegate: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: - 导出日记 管理器
class ExportDiaryManager {
    var delegate: ExportDiaryControllerDelegate?
    
    var document: UIDocumentInteractionController?
    
    let baseImageURL = URL(fileURLWithPath: FileManager.tmpPath + DairyImageAPI.imagePath + "/")
    
    let diaryHeader = ""
}

// MARK: - dairy to html
extension ExportDiaryManager {
    /// 将  diary 拼接成完整的 HTML 字符串，并加载到 webview 中
    /// - Parameter diaries: 日记数组
    func loadDiaryToHtml(diaries: [DairyModel], isNeedImagePathReplaced: Bool = true) {
        var htmlString = ""
        
        var newDiaries = diaries
        if isNeedImagePathReplaced {
            /// 替换 image prath 后的日记数组
            newDiaries = DairyAPI.formatDairyImagePath(dairies: diaries)
        }
        
        /// 拼接
        newDiaries.forEach {
            let header = generateDiaryHTMLHeader(diary: $0)
            htmlString += header + formatHtmlString(html: $0.content)
        }
        
        /// 消除 padding 问题
        htmlString = "<div style=\"box-sizing: border-box; margin-left: 24px;\">" + htmlString + "</div>"
        
        delegate?.tmpWebview.loadHTMLString(htmlString, baseURL: baseImageURL)
    }
    
    /// 生成 日记 头部，时间，位置，天气等
    func generateDiaryHTMLHeader(diary: DairyModel) -> String {
        let line = "<div style=\"padding-top: 50px; border-bottom: 1px solid #909399; width: 100%;\"></div>"
        let left = "<div style=\"font-size: 14px; color: #606266; margin: 4px 0;\">"
        let right = "</div>"
        let date = left + "时间：\(diary.createdAt.toFormat("yyyy年MM月dd日")) \(diary.createdAt.weekdayName(.default, locale: Locales.chineseSimplified)) \(diary.createdAt.toFormat("a hh时mm分"))" + right
        var address = ""
        if diary.location != "" {
            LocationAPI.getLocation(diaryId: Int(diary.location)!) { location in
                if let location = location {
                    address = left + "位置：\(location.address)" + right
                }
            }
        }
        
        var weatherStr = ""
        if diary.weather != "" {
            for weather in Weathers.locale {
                if weather.id == diary.weather {
                    weatherStr = left + "天气：\(weather.name)" + right
                }
            }
        }
        
        var moodStr = ""
        if diary.mood != "" {
            for mood in Moods.all {
                if mood.image == diary.mood {
                    moodStr = left + "心情：\(mood.title)" + right
                }
            }
        }
        
        let space = "<div style=\"height: 16px;\"></div>"
        
        var title = ""
        if diary.title != "" {
            title = "<div style=\"font-size: 24px; font-color: #303133; margin-botton: 16px;\">\(diary.title)</div>"
        }
        
        return line + date + address + weatherStr + moodStr + space + title
    }
    
    /// 格式化html String (添加 image 样式)
    /// - Parameter html: 返回添加样式后的html string
    func formatHtmlString(html: String) -> String {
        CLog("html的值为: \(html)")
        
        let pattern = "<img src=\\\"\(FileManager.tmpPath + DairyImageAPI.imagePath)/\(DairyImageAPI.prefix)[0-9]{15}\\\""
        CLog("pattern的值为: \(pattern)")
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex.matches(in: html, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, html.count))
        
        /// 新的HTML
        var newHTML = html
        
        CLog("res的值为: \(res)")
        for checkingRes in res {
            CLog("checkingRes的值为: \(checkingRes)")
            let res = (html as NSString).substring(with: checkingRes.range)
            newHTML = newHTML.replacingOccurrences(of: res, with: res + " style=\"max-width: 70%; max-height: 800px; display: block; margin: 8px auto;\"")
        }
        return newHTML
    }
}

// MARK: - 导出功能
extension ExportDiaryManager {
    func exportHTMLContentToPDF(fileName: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        guard let delegate = delegate else { return }
        
        let formater = delegate.tmpWebview.viewPrintFormatter()
        
        _ =
            printPageRenderer.addPrintFormatter(formater, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        let path = DairyImageAPI.gengerateDir(type: .tmp)
        
        let pdfFilename = "\(path)/\(fileName).pdf"
        
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
        
        document = UIDocumentInteractionController.init(url: URL(fileURLWithPath: pdfFilename))
        CLog("dcou的值为: \(document)")
        document?.delegate = delegate
        
        let canOpen = document?.presentPreview(animated: true)
        //        let canOpen = document.presentOpenInMenu(from: view.bounds, in: view, animated: true)
        delegate.hub?.hide(animated: true)
        CLog("canOp的值为: \(canOpen)")
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
}


