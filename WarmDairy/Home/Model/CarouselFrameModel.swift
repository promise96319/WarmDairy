//
//  CarouselFrameModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CarouselFrameModel {
    static var cellWidth: CGFloat {
        if DeviceInfo.isInch40 {
            return 275 / 375 * DeviceInfo.screenWidth
        }
        
        if DeviceInfo.isInch47 {
            return 250 / 375 * DeviceInfo.screenWidth
        }
        
        return 275 / 375 * DeviceInfo.screenWidth
    }
    
    static var cellHeight: CGFloat {
        if DeviceInfo.isInch40 {
            return 180 * 400 / 275
        }
        
        if DeviceInfo.isiPad {
            return CarouselFrameModel.cellWidth * 360 / 275
        }
        
        return CarouselFrameModel.cellWidth * 400 / 275
    }
    
    static let horizontalSpacing: CGFloat = 20
}
