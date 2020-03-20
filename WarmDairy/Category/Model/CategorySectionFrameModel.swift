//
//  CategorySectionFrameModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CategorySectionFrameModel {
    static let spacing: CGFloat = 24
    static let cellWidth: CGFloat = (DeviceInfo.screenWidth - spacing * 3 - 16) / 2
    static let cellHeight: CGFloat = cellWidth * 3 / 2
    static let cellVerticalSpacing: CGFloat = 12
    static let sectionSpacing: CGFloat = 32
    static let sectionHeader: CGFloat = 28
    static let sectionHeight: CGFloat = cellHeight + sectionSpacing + sectionHeader + cellVerticalSpacing * 2
}
