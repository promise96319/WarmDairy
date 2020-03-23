//
//  RecordTimeManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class RecordTimeManager {
    var minutes = 0
    
    var recordTimer: DispatchSourceTimer?
    
    func startRecordTimer() {
        CLog("开始计时======================================")
        recordTimer = DispatchSource.makeTimerSource()
        recordTimer?.schedule(deadline: .now() + 60, repeating: 60)
        recordTimer?.setEventHandler(handler: { [weak self] in
            CLog(self?.minutes)
            self?.minutes += 1
        })
        recordTimer?.resume()
    }
    
    func stopRecordTimer() {
        CLog("结束计时======================================")
        CLog(minutes)
        recordTimer?.cancel()
        recordTimer = nil
        
        UserInfoAPI.saveRecordTime(minutes: minutes)
        
        minutes = 0
    }
}
