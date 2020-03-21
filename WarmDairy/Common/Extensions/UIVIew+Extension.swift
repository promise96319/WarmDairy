//
//  UIVIew+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 16
    }
}
