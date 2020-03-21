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
    var backgroundColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if backgroundImage != nil {
            let imageView = UIImageView.init(frame: self.view.frame)
            imageView.contentMode = .scaleAspectFill
            imageView.image = backgroundImage
            self.view.insertSubview(imageView, at: 0)  
        }
        
        if backgroundColor != nil {
            _ = UIView().then {
                $0.backgroundColor = UIColor(hexString: backgroundColor!, alpha: 0.9)
                view.insertSubview($0, at: 1)
                $0.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
    }
}
