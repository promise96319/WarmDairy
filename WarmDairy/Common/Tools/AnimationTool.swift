//
//  AnimationTool.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import ViewAnimator

class AnimationTool {
    static let shared = AnimationTool()
    
    func buttonScale(view: UIView) {
        let scaleAnimation = AnimationType.zoom(scale: 0.2)
        
        view.animate(animations: [scaleAnimation], reversed: false, initialAlpha: 1, finalAlpha: 1, delay: 0, duration: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, completion: nil)
    }
//    let fromAnimation = AnimationType.from(direction: .bottom, offset: 160.0)
//    view.animate(animations: [fromAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, completion: nil)
}
