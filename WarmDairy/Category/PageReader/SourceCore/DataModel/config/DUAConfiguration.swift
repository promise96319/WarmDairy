//
//  DUAConfig.swift
//  DUAReader
//
//  Created by mengminduan on 2017/12/26.
//  Copyright © 2017年 nothot. All rights reserved.
//

import UIKit

enum DUAReaderScrollType: Int {
    case curl
    case horizontal
    case vertical
    case none
}

enum ReaderBg: String {
    case white = "F6F7F9"
    case green = "C7EAC9"
    case yellow = "F0EDD9"
    static let all: [ReaderBg] = [.white, .green, .yellow]
}

enum DUAReaderBookType {
    case txt
    case epub
}

class DUAConfiguration: NSObject {

    var contentFrame = CGRect()
    var lineHeightMutiplier: CGFloat = 2 {
        didSet {
            self.didLineHeightChanged(lineHeightMutiplier)
        }
    }
    var fontSize: CGFloat = 18 {
        didSet {
            self.didFontSizeChanged(fontSize)
        }
    }
    var fontName:String! {
        didSet {
            self.didFontNameChanged(fontName)
        }
    }
    var backgroundImage:UIImage! {
        didSet {
            self.didBackgroundImageChanged(backgroundImage)
        }
    }
    var backgroundColor: ReaderBg! {
        didSet {
            self.didBackgroundColorChanged(backgroundColor)
        }
    }
    
    var scrollType = DUAReaderScrollType.curl {
        didSet {
            self.didScrollTypeChanged(scrollType)
        }
    }
    
    var bookType = DUAReaderBookType.epub
    
    var didFontSizeChanged: (CGFloat) -> Void = {_ in }
    var didFontNameChanged: (String) -> Void = {_ in }
    var didBackgroundImageChanged: (UIImage) -> Void = {_ in }
    var didBackgroundColorChanged: (ReaderBg) -> Void = {_ in }
    var didLineHeightChanged: (CGFloat) -> Void = {_ in }
    var didScrollTypeChanged: (DUAReaderScrollType) -> Void = {_ in }

    override init() {
        super.init()
        let font = UIFont.systemFont(ofSize: self.fontSize)
        self.fontName = font.fontName
        let safeAreaTopHeight: CGFloat = UIScreen.main.bounds.size.height == 812.0 || UIScreen.main.bounds.size.height == 896.0 ? 44 : 0
        let safeAreaBottomHeight: CGFloat = UIScreen.main.bounds.size.height == 812.0 || UIScreen.main.bounds.size.height == 896.0 ? 34 : 0
        self.contentFrame = CGRect(x: 30, y: 30 + safeAreaTopHeight, width: UIScreen.main.bounds.size.width - 60, height: UIScreen.main.bounds.size.height - 60.0 - safeAreaTopHeight - safeAreaBottomHeight)
    }
}
