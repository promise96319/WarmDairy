//
//  DUAPageViewController.swift
//  DUAReader
//
//  Created by mengminduan on 2017/12/26.
//  Copyright © 2017年 nothot. All rights reserved.
//

import UIKit

class DUAContainerPageViewController: UIPageViewController {
    var willStepIntoNextChapter = false
    var willStepIntoLastChapter = false
    
}

class DUAtranslationControllerExt: DUAtranslationController {
    var willStepIntoNextChapter = false
    var willStepIntoLastChapter = false
}

class DUAPageViewController: UIViewController {
    
    var index: Int = 1
    var chapterBelong: Int = 1
    var backgroundImage: UIImage?
    lazy var backgroundMask = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if backgroundImage != nil {
            let imageView = UIImageView.init(frame: self.view.frame)
            imageView.contentMode = .scaleAspectFill
            imageView.image = backgroundImage
            self.view.insertSubview(imageView, at: 0)  
        }
        
        _ = backgroundMask.then {
            $0.backgroundColor = UIColor(hexString: ReaderBg.yellow.rawValue, alpha: 0.9)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
