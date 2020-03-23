//
//  MessageTool.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/23.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import SwiftMessages

class MessageTool {
    static let shared = MessageTool()
    
    private init() {}
    
    func showMessage(theme: Theme = .success,
                     title: String = "",
                     body: String = "",
                     duration: TimeInterval = 2
                     ) {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(theme, iconStyle: .default)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        var config = SwiftMessages.defaultConfig
        config.duration  = .seconds(seconds: duration)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: view)
    }
}

