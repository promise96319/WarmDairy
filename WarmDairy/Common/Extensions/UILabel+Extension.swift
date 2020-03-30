//
//  UILabel+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

extension UILabel {
    func set(text: String, size: CGFloat = 16, weight: UIFont.Weight = .regular, color: String = "303133", font: String = "") {
        self.text = text
        self.textColor = UIColor(hexString: color)
        if font == "" {
            self.font = UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            self.font = UIFont(name: "", size: size)
        }
    }
    
    
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, letterSpacing: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
