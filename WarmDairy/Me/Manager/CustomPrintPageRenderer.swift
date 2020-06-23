//
//  CustomPrintPageRenderer.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/5.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
     
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
     
        let contentRect = CGRect(x: 24, y: 24, width: A4PageWidth - 48, height: A4PageHeight - 96)
        self.setValue(NSValue(cgRect: contentRect), forKey: "printableRect")
    }
}
