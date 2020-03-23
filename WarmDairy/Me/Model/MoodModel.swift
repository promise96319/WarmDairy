//
//  MoodModel.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

class MeMoodFrameModel {
    static let width = DeviceInfo.screenWidth - 16 * 2 - 16 * 2
    static let height = 200
    static let cellWidth = 72
    static let cellHeight = 200
}

class MoodModel {
    var image: String = ""
    var title: String = ""
    var color: String = ""
    var dairyCount: Int = 0
    init(image: String, title: String, color: String, count: Int = 0) {
        self.image = image
        self.title = title
        self.color = color
        self.dairyCount = count
    }
}

//[("happy", "开心"), ("proud", "得意"), ("enrich", "充实"), ("surprise", "惊喜")],
//[("surprised", "惊讶"), ("confused", "迷茫"), ("lonely", "孤独"), ("sad", "难过")],
//[("wantcry", "委屈"), ("fidgety", "烦躁"), ("cry", "大哭"), ("angry", "生气")],
class Moods {
    static let all = [
        MoodModel(image: "happy", title: "开心", color: "FFFBC4"),
        MoodModel(image: "proud", title: "得意", color: "EDFFEA"),
        MoodModel(image: "enrich", title: "充实", color: "FFFEEC"),
        MoodModel(image: "surprise", title: "惊喜", color: "FFE3ED"),
        
        MoodModel(image: "surprised", title: "惊讶", color: "F4EEFF"),
        MoodModel(image: "confused", title: "迷茫", color: "F8E4D7"),
        MoodModel(image: "lonely", title: "孤独", color: "C6D6DE"),
        MoodModel(image: "sad", title: "难过", color: "C1E1C4"),
       
        MoodModel(image: "wantcry", title: "委屈", color: "D3EDF9"),
        MoodModel(image: "fidgety", title: "烦躁", color: "D1CEBD"),
        MoodModel(image: "cry", title: "大哭", color: "BCE2EC"),
        MoodModel(image: "angry", title: "生气", color: "EE9CA7"),
    ]
}
