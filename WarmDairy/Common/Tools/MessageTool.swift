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
        
        switch theme {
        case .success:
            view.configureTheme(backgroundColor: UIColor(hexString: "#67C23A", alpha: 1)!, foregroundColor: UIColor(hexString: "ffffff")!, iconImage: R.image.icon_mood_happy()!, iconText: nil)
        case .error:
            view.configureTheme(backgroundColor: UIColor(hexString: "#F56C6C", alpha: 1)!, foregroundColor: UIColor(hexString: "ffffff")!, iconImage: R.image.icon_mood_cry()!, iconText: nil)
        case .warning:
            view.configureTheme(backgroundColor: UIColor(hexString: "#E6A23C", alpha: 1)!, foregroundColor: UIColor(hexString: "ffffff")!, iconImage: R.image.icon_mood_confused()!, iconText: nil)
        case .info:
            view.configureTheme(backgroundColor: UIColor(hexString: "#909399", alpha: 1)!, foregroundColor: UIColor(hexString: "ffffff")!, iconImage: R.image.icon_mood_enrich()!, iconText: nil)
        }
        
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.configureIcon(withSize: CGSize(width: 36, height: 36), contentMode: .scaleAspectFill)
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
    
    func showLoading(title: String = "",
                     body: String = "") {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(backgroundColor: UIColor(hexString: "#67C23A", alpha: 1)!, foregroundColor: UIColor(hexString: "ffffff")!, iconImage: R.image.icon_mood_happy()!, iconText: nil)
        view.configureDropShadow()
        view.configureContent(title: title, body: body, iconImage: R.image.icon_mood_happy()!)
        view.configureIcon(withSize: CGSize(width: 36, height: 36), contentMode: .scaleAspectFill)
        
        view.button?.isHidden = true
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: view)
    }
    

    
    func hideMessage() {
        SwiftMessages.hide()
    }
    
    func hideLoading() {
        SwiftMessages.hide()
    }
}

