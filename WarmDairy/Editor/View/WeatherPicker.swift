//
//  WeatherPicker.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/17.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class WeatherFrameModel {
    static let totalWidth: CGFloat = DeviceInfo.screenWidth - 2 * 24
    static let totalHeight: CGFloat = 64 * 2 + CGFloat(Weathers.all.count) * (54 + 20)
}

enum Weathers: String {
    case sun = "sun"
    case couldSun = "cloud_sun"
    case wind = "wind"
    case rainbow = "rainbow"
    case cloud = "cloud"
    case light = "light"
    case rain = "rain"
    case snow = "snow"
    static let all: [[Weathers]] = [
        [.sun, .couldSun, .wind, .rainbow],
        [.cloud, .light, .rain, .snow]
    ]
}

class WeatherPicker: UIView {
    
    weak var delegate: EditorViewController?
    
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    deinit {
        CLog("weather注销")
    }
}

// MARK: - 事件处理
extension WeatherPicker {
    @objc func chooseWeather(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let col = tag % 10
        let row = Int(tag / 10) - 1
        delegate?.chooseWeather(weather: Weathers.all[row][col].rawValue)
    }
}

extension WeatherPicker {
    func setupUI() {
        backgroundColor = UIColor(hexString: "F1F6FA")
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 16
        
        _ = titleLabel.then {
            $0.text = "天气"
            $0.textColor = UIColor(hexString: "303133")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(24)
            }
        }
        
        for (row, weathers) in Weathers.all.enumerated() {
            let stackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.alignment = .center
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.height.equalTo(54)
                    $0.width.equalTo(WeatherFrameModel.totalWidth - 2 * 16)
                    $0.top.equalTo(titleLabel.snp.bottom).offset(32 + (54 + 32) * row)
                    $0.centerX.equalToSuperview()
                }
            }
            
            for (col, weather) in weathers.enumerated() {
                let itemStack = UIStackView().then {
                    $0.axis = .vertical
                    $0.distribution = .fillEqually
                     $0.alignment = .center
                }
                
                let imageView = UIImageView().then {
                    $0.isUserInteractionEnabled = true
                    $0.image = UIImage(named: "icon_weather_\(weather.rawValue)")
                    $0.contentMode = .scaleAspectFill
                    itemStack.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.width.height.equalTo(54)
                    }
                    $0.tag = (row + 1) * 10 + col
                }
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseWeather))
                imageView.addGestureRecognizer(tapGesture)
                stackView.addArrangedSubview(itemStack)
            }
        }
    }
}
