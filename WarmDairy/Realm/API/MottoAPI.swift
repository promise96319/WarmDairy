//
//  MottoAPI.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/18.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyUserDefaults

class MottoAPI {
    static func getMottos(callback: @escaping(_ data: [MottoModel]) -> Void) {
        let realm = try! Realm()
        let res: [MottoModel] = realm.objects(MottoModel.self).filter("isDeleted = false").sorted(byKeyPath: "id", ascending: true).map { $0 }
        callback(res)
    }
    
    static func getMotto(mottoId: Int, callback: @escaping(_ data: MottoModel?) -> Void) {
        let realm = try! Realm()
        let res: MottoModel? = realm.objects(MottoModel.self).filter("isDeleted = false AND id = \(mottoId)").first
        callback(res)
    }
    
    /// 添加motto
    /// - Parameters:
    ///   - date: motto的日期
    ///   - callback:
    /// 1. 搜索是否存在motto
    /// 2. 如果没有motto，则创建motto
        /// 2.1 如果是今天的motto，则用本地motto创建，并删除本地motto
        /// 2.2 如果不是今天的，则随机创建一个
    static func addMotto(date: Date, callback: @escaping(_ isAdded: Bool) -> Void) {
        let realm = try! Realm()
        let id = Int(date.toFormat("yyyyMMdd"))!
        let res = realm.objects(MottoModel.self).filter("id = \(id)")
        if res.count > 0 {
            callback(true)
            return
        }
        
        let motto = MottoModel()
        motto.id = id
        motto.date = date
        if date.compare(.isToday) && Defaults[.todayMottoImage] != "" {
            motto.imageURL = Defaults[.todayMottoImage]
            motto.motto = Defaults[.todayMotto]
            motto.author = Defaults[.todayMottoAuthor]
            Defaults[.todayMottoImage] = ""
            Defaults[.todayMotto] = ""
            Defaults[.todayMottoAuthor] = ""
            
            try! realm.write {
                realm.add(motto)
            }
            callback(true)
        } else {
            let mottoCount = realm.objects(MottoModel.self).count
            let randomMotto = generateRandomMotto(index: mottoCount + 1)
            motto.imageURL = randomMotto.0
            motto.motto = randomMotto.1
            motto.author = randomMotto.2
            try! realm.write {
                realm.add(motto)
            }
            callback(true)
        }
    }
    
    /// 生成随机motto （image, motto, author）
    /// 参数 Int。如果是生成motto, 根据已有的motto 数量，生成下一个。否则随机一个。
    static func generateRandomMotto(index: Int = -1) -> (String, String, String) {
        if (index >= 0 && index < mottos.count ) {
            return mottos[index]
        } else {
            let randomIndex = Int.random(in: 0..<mottos.count)
            return mottos[randomIndex]
        }
    }
    
    /// mottos 数组：[(image, motto, author)...]
    static let mottos = [
        // 1-10
        ("https://app.dairy.qinguanghui.com/2_morning-2264051.jpg", "放弃不难，但坚持一定很酷。", "作家，东野圭吾"),
        
        ("https://app.dairy.qinguanghui.com/17_iceland-1979445_1920.jpg", "你再不来，我要下雪了。", "作家，木心"),
        
        ("https://app.dairy.qinguanghui.com/18_wil-stewart-UErWoQEoMrc-unsplash.jpg", "酒 — 以水的状态流淌，以火的性格燃烧。", "诗人，莎士比亚"),
        ("https://app.dairy.qinguanghui.com/5_rough-horn-2146181_1920.jpg", "天空没有翅膀的痕迹，而我已飞过。", "诗人，泰戈尔"),
        
        ("https://app.dairy.qinguanghui.com/16_night-photograph-2183637_1920%20%281%29.jpg", "今夜我不关心人类，我只想你。", "诗人,海子"),
        ("https://app.dairy.qinguanghui.com/3_reading-925589_1920.jpg", "总之岁月漫长，然而值得等待。", "作家，村上春树"),
        
            ("https://app.dairy.qinguanghui.com/avatar.jpg", "生如夏花之绚烂，死如秋叶之静美。", "诗人，泰戈尔"),
       ("https://app.dairy.qinguanghui.com/4_pine-trees-1209656_1920.jpg", "活在这珍贵的人间，太阳强烈，水波温柔。", "诗人，海子"),
        ("https://app.dairy.qinguanghui.com/1_blur-1283865_1920.jpg", "笑，全世界便与你同声笑，哭，你便独自哭。", "作家，张爱玲"),
        ("https://app.dairy.qinguanghui.com/7_paper-1100254_1920.jpg", "从前车马很慢，书信很远，一生只够爱一人。", "作家，木心"),
        ("https://app.dairy.qinguanghui.com/6_rose-3711830_1920.jpg", "不管我本人多么平庸，我总觉得对你的爱很美。", "作家，王小波"),
        ("https://app.dairy.qinguanghui.com/8_sean-o-KMn4VEeEPR8-unsplash.jpg", "我来到这个世界，为了看看太阳和蓝色的地平线。", "诗人，北岛"),
        ("https://app.dairy.qinguanghui.com/9_tea-time-3240766_1920.jpg", "自爱，沉稳，而后爱人。", "作家 亦舒"),
        ("https://app.dairy.qinguanghui.com/10_johannes-plenio-RwHv7LgeC7s-unsplash.jpg", "生命有裂缝，阳光才照得进来", "作家，毕淑敏"),
        
        // 11-20
        ("https://app.dairy.qinguanghui.com/11_bird-383245_1920.jpg", "我的人生就像在白夜里走路。", "作家，东野圭吾"),
        ("https://app.dairy.qinguanghui.com/12_coffee-2390136_1920.jpg", "白的花胜似绿的叶 浓的酒不如淡的茶", "作家，冰心"),
        ("https://app.dairy.qinguanghui.com/10_mountains-736886.jpg", "我爱哭的时候便哭，想笑的时候便笑。只要这一切出于自然。我不求深刻，只求简单。", "作家，三毛"),
        ("https://app.dairy.qinguanghui.com/13_tree-838667%20%281%29.jpg", "没有被听见不是沉默的理由。", "作家，雨果"),
        ("https://app.dairy.qinguanghui.com/14_landscape-1732651_1920.jpg", "你连指尖都泛出好看的颜色。", "作家，川端康成"),
        
        ("https://app.dairy.qinguanghui.com/19_pretty-woman-1509956_1920.jpg", "每一个不曾起舞的日子，都是对生命的辜负。", "哲学家，尼采"),
       
        // 21-30
        ("https://app.dairy.qinguanghui.com/21_pietro-de-grandi-T7K4aEPoGGk-unsplash.jpg", "一个人的行走范围，就是他的世界。", "诗人，北岛"),
        ("https://app.dairy.qinguanghui.com/22_landscape-2990060_1920.jpg", "我不知道将去何方，但我已在路上。", "动画导演，宫崎骏"),
        ("https://app.dairy.qinguanghui.com/23_legs-434918_1920.jpg", "无论做什么，记得为自己而做，那就毫无怨言。", "作家，亦舒"),
        ("https://app.dairy.qinguanghui.com/24_ocean-3605547.jpg", "黑夜无论怎样悠长，白昼总会到来。", "诗人，莎士比亚"),
        ("https://app.dairy.qinguanghui.com/25_soap-bubble-1958650_1920.jpg", "生命中的全部偶然，其实都是命中注定。是为宿命。", "作家，东野圭吾"),
        ("https://app.dairy.qinguanghui.com/26_water-880462_1920.jpg", "眼愈多流泪而愈见清明，心因饱经忧患而愈加温厚。", "作家，冰心"),
        ("https://app.dairy.qinguanghui.com/27_marguerite-729510_1920.jpg", "人的命就像这琴弦，拉紧了才能弹好，弹好了就够了。", "作家，史铁生"),
        ("https://app.dairy.qinguanghui.com/28_landscape-4410506_1920.jpg", "我需要，最狂的风，和最静的海。", "诗人，顾城"),
        ("https://app.dairy.qinguanghui.com/29_boy-1822614_1920.jpg", "幸福就是一双鞋合不合适只有自己一个人知道", "作家，大仲马"),
        ("https://app.dairy.qinguanghui.com/30_water-955929.jpg", "眼睛为她下着雨，心却为她打着伞，这就是爱情。", "诗人，泰戈尔"),
        
        // 31-40
        ("https://app.dairy.qinguanghui.com/31_rain-stoppers-1461288_1280.jpg", "雨是一生错过，雨是悲欢离合", "诗人,海子"),
        ("https://app.dairy.qinguanghui.com/32_beach-2179183_1920.jpg", "一个人自以为刻骨铭心的回忆。别人也许早已经忘记了。", "作家，张小娴"),
        ("https://app.dairy.qinguanghui.com/33_sparkler-4724867_1920.jpg", "岁月极美，在于它必然的流逝。春花、秋月、夏日、冬雪。", "作家，三毛"),
        ("https://app.dairy.qinguanghui.com/34_people-2562102_1920.jpg", "冗长的黑暗中，你是我唯一的光。", "作家，东野圭吾"),
        ("https://app.dairy.qinguanghui.com/35_narrative-794978_1920.jpg", "凡心所向，素履可往。", "作家，木心"),
        ("https://app.dairy.qinguanghui.com/36_daniela-cuevas-t7YycgAoVSw-unsplash.jpg", "人总是在接近幸福时倍感幸福，在幸福进行时却患得患失。", "作家，张爱玲"),
        ("https://app.dairy.qinguanghui.com/37_hiker-1082297_1920.jpg", "人不要太任性，因为你是活给未来的你。不要让未来的你讨厌现在的你。", "主持人，蔡康永"),
        ("https://app.dairy.qinguanghui.com/38_sea-2562563_1920.jpg", "人的一生是短的，但如果卑劣地过这一生，就太长了。", "诗人，莎士比亚"),
        ("https://app.dairy.qinguanghui.com/39_heart-shape-1714807_1280.jpg", "爱原来是一种经历。", "作家，张小娴"),
        ("https://app.dairy.qinguanghui.com/40_storytelling-4203628_1920.jpg", "和时间比赛，我们永远是输家，只有多做点事情，虽败犹荣。", "作家，亦舒"),
        
        // 41-50
        ("https://app.dairy.qinguanghui.com/41_dark-2024127_1280.png", "星星发亮是为了让每一个人有一天都能找到属于自己的星星", "作家 - 安托万·德·圣·埃克苏佩里"),
        ("https://app.dairy.qinguanghui.com/42_winter-landscape-2571788_1920.jpg", "要有最朴素的生活和最遥远的梦想，即使明天天寒地冻，山高水远，路远马亡。", "诗人，海子"),
        ("https://app.dairy.qinguanghui.com/43_matthew-fournier-_OOtK2orf5Q-unsplash.jpg", "即使翅膀折了，心也要飞翔。", "诗人，泰戈尔"),
        ("https://app.dairy.qinguanghui.com/44.adventure-1807524_1920.jpg", "踏着荆棘，也不觉悲苦；有泪可落，亦不是悲凉。", "作家，冰心"),
        ("https://app.dairy.qinguanghui.com/45_rose-165819_1920%20%281%29.jpg", "爱所有人，信任少数人，不负任何人。", "诗人，莎士比亚"),
        ("https://app.dairy.qinguanghui.com/46.keegan-houser--Q_t4SCN8c4-unsplash.jpg", "心，一旦离开了，就再不会回来。", "作家，东野圭吾"),
        ("https://app.dairy.qinguanghui.com/47_snow-3373432_1920.jpg", "家人闲坐，灯火可亲", "诗人，汪曾祺"),
        ("https://app.dairy.qinguanghui.com/48_filipe-almeida-hQuQwfY8QoE-unsplash.jpg", "草在结它的种子，风在摇它的叶子。我们站着，不说话，就十分美好。", "诗人，顾城"),
        ("https://app.dairy.qinguanghui.com/49_young-woman-1745173_1920.jpg", "何必遗憾本不能的事情。", "作家，雨果"),
        ("https://app.dairy.qinguanghui.com/50_tree-736885.jpg", "没有任何夜晚能使我沉睡，没有任何黎明能使我醒来。", "诗人，海子"),
    ]
}

