//
//  MoodPicker.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/17.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class MoodFrameModel {
    static let totalWidth: CGFloat = DeviceInfo.screenWidth - 2 * 24
    static let totalHeight: CGFloat = 180 + 3 * (54 + 20)
}

class MoodPicker: UIView {
    
    weak var delegate: EditorViewController?
    
    var allMoods = [
        [("happy", "开心"), ("proud", "得意"), ("enrich", "充实"), ("surprise", "惊喜")],
        [("surprised", "惊讶"), ("confused", "迷茫"), ("lonely", "孤独"), ("sad", "难过")],
        [("wantcry", "委屈"), ("fidgety", "烦躁"), ("cry", "大哭"), ("angry", "生气")],
    ]
    
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
}

// MARK: - 事件处理
extension MoodPicker {
    @objc func chooseWeather(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let col = tag % 10
        let row = Int(tag / 10) - 1
        delegate?.chooseMood(mood: allMoods[row][col].0)
    }
}

extension MoodPicker {
    func setupUI() {
        backgroundColor = UIColor(hexString: "F1F6FA")
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 16
        
        _ = titleLabel.then {
            $0.text = "心情"
            $0.textColor = UIColor(hexString: "303133")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(24)
            }
        }
        
        for (row, moods) in allMoods.enumerated() {
            let stackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.alignment = .center
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.height.equalTo(74)
                    $0.width.equalTo(WeatherFrameModel.totalWidth - 2 * 16)
                    $0.top.equalTo(titleLabel.snp.bottom).offset(32 + (74 + 32) * row)
                    $0.centerX.equalToSuperview()
                }
            }
            
            for (col, mood) in moods.enumerated() {
                let itemStack = UIStackView().then {
                    $0.axis = .vertical
                    $0.distribution = .fillEqually
                    $0.spacing = 4
                    $0.alignment = .center
                }
                
                _ = UIImageView().then {
                    $0.isUserInteractionEnabled = true
                    $0.image = UIImage(named: "icon_mood_\(mood.0)")
                    $0.contentMode = .scaleAspectFill
                    itemStack.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.width.height.equalTo(48)
                    }
                }
                _ = UILabel().then {
                    $0.text = mood.1
                    $0.font = UIFont.systemFont(ofSize: 16)
                    $0.textColor = UIColor(hexString: "303133")
                    itemStack.addArrangedSubview($0)
                }
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseWeather))
                itemStack.addGestureRecognizer(tapGesture)
                itemStack.tag = (row + 1) * 10 + col
                stackView.addArrangedSubview(itemStack)
            }
        }
    }
}

