//
//  ToolbarModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class ToolbarFrameModel {
    static let height: CGFloat = 44
    static let cellHeight: CGFloat = ToolbarFrameModel.height
    static let cellWidth: CGFloat = ToolbarFrameModel.height
    static let verticleSpacing: CGFloat = 0
}

enum ToolOptions {
    case none
    case image
    case font
    case fontsize
    case fontcolor
    case bold
    case italic
    case underline
    case align_left
    case align_center
    case align_right
    case undo
    case redo
    
    static let all: [ToolOptions] = [.image, .fontsize, .fontcolor, .bold, .italic, .underline, .align_left, .align_center, .align_right, .undo, .redo]
}
