//
//  PasswordManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/29.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import LocalAuthentication

class PasswordManager {
    static let shared = PasswordManager()
    private init() {}
}

extension PasswordManager {
    func passwordAuth(reason: String, callback: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                callback(success)
            }
        } else {
            DispatchQueue.main.async {
                MessageTool.shared.showMessage(theme: .error, title: "解锁失败", body: (error?.localizedDescription)!)
            }
            callback(false)
        }
    }
}
