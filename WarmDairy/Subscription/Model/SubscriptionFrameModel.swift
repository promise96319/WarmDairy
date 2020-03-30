//
//  SubscriptionFrameModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/25.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class SubscriptionFrameModel {
    static let headerMaxHeight: CGFloat = 260
    static let headerMinHeight: CGFloat = 218
    static var bgViewRadius: CGFloat {
        if DeviceInfo.isiPad {
            return 1024
        }
        return 520
    }
    
    static let checkCellSpacing: CGFloat = 14
    static let checkCellHeight: CGFloat = 26
    static let checkCellFontSize: CGFloat = 18
    static var checkCellLeftSpaing: CGFloat {
        if DeviceInfo.isInch40 {
            return 24
        }
        
        return 64
    }
    
    static let buttonHeight: CGFloat = 56
    static let buttonRadius: CGFloat = 12
    
    static var restoreHeight: CGFloat {
        if DeviceInfo.isInch40 {
            return 28
        }
        return 14
    }
    
    static var policyHeight: CGFloat {
        if DeviceInfo.isInch40 {
            return 28
        }
        return 14
    }
}
