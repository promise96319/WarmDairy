//
//  SubscriptionViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/23.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import AVFoundation

class SubscriptionViewController: UIViewController {
    
    lazy var backButton = UIButton()
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension SubscriptionViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

extension SubscriptionViewController {
    func setupUI() {
        setupVideo()
        setupBg()
    }
    
    func setupVideo() {
        playerItem = AVPlayerItem(url: getFileURLFrom(fileName: "winternight"))
        player = AVPlayer.init(playerItem: playerItem)
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.frame
        
        player.volume = 0
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func playDidEnd() {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    func getFileURLFrom(fileName: String) -> URL {
        let bundlePath = Bundle.main.path(forResource: "GIF", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        bundle?.load() // 一定要加载bundle，使其变为可运行
        
        let urlString = bundle?.path(forResource: fileName, ofType: "mp4")
        
        return URL.init(fileURLWithPath: urlString!)
    }
    
    func setupBg() {
        
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(8)
                $0.left.equalToSuperview().offset(8)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
