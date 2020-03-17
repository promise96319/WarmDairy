//
//  ReaderViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    var mreader: DUAReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//
//        guard let bundlePath = Bundle.main.path(forResource: "Books", ofType: "bundle") else { return }
//        let bundle = Bundle(path: bundlePath)
//        bundle?.load()
//
//        guard let filePath = bundle?.path(forResource: "index", ofType: "html") else { return }
//
//        print("测试 ===> file的值为: \(filePath)")
////        URL(fileURLWithPath: filePath)
////
//        let htmlData = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
//        if htmlData == nil {
//            return
//        }
////
////        print("测试 ===> ht的值为: \(htmlData)")
////
//        let attrString: NSAttributedString? = try? NSAttributedString(data: htmlData!, options: [:], documentAttributes: nil)
////
//        print("测试 ===> att的值为: \(attrString)")
////
        
        
    }
}

extension ReaderViewController: DUAReaderDelegate {
    func readerDidClickSettingFrame(reader: DUAReader) {
        
    }
    
    func reader(reader: DUAReader, readerStateChanged state: DUAReaderState) {
        
    }
    
    func reader(reader: DUAReader, readerProgressUpdated curChapter: Int, curPage: Int, totalPages: Int) {
        
    }
    
    func reader(reader: DUAReader, chapterTitles: [String]) {
        
    }
    
}

extension ReaderViewController {
    func setupUI() {
        mreader = DUAReader()
               let configuration = DUAConfiguration.init()
        configuration.backgroundImage = R.image.image_editor_bg()
               configuration.bookType = .epub
               mreader.config = configuration
               mreader.delegate = self
               self.present(mreader, animated: true, completion: nil)
//               guard let epubPath = Bundle.main.path(forResource: "每天懂一点好玩心理学2", ofType: "epub") else {
//                   print("测试 ===> epubP的值为")
//                   return
//               }
//               print("测试 ===> epubPat的值为: \(epubPath)")
               mreader.readWith(filePath: "epubPath", pageIndex: 1)
    }
}
