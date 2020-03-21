//
//  Log.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

//MARK: - 自定义打印函数
func CLog<T>(_ message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line){
    
    #if DEBUG
    
    let file = (file as NSString).lastPathComponent;
    
//    print("\(file):(\(lineNum)) && method: \(funcName) ========> \(message)");
    print("\(file):(\(lineNum)) =====> \(message)");
    
    #endif
}
