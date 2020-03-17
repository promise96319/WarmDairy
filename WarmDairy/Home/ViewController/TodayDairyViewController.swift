//
//  TodayDairyViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/16.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import RQShineLabel

class TodayDairyViewController: UIViewController {
    
    lazy var bgImage = UIImageView()
    lazy var bgMask = UIView()
    lazy var backButton = UIButton()
    lazy var dayLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var weekLabel = UILabel()
    lazy var dateLine = UIView()
    lazy var mottoLabel = RQShineLabel()
    lazy var authorLabel = UILabel()
    lazy var lineView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mottoLabel.shine()
    }
}

// MARK: - 事件处理
extension TodayDairyViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI 界面
extension TodayDairyViewController {
    func setupUI() {
        setupBack()
        setupDate()
        setupMotto()
    }
    
    func setupMotto() {

        _ = mottoLabel.then {
            $0.text = "东边日出西边雨，道是无晴还有晴，曾经沧海难为水，除却巫山不是云"
            $0.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(24)
                $0.width.equalTo(DeviceInfo.screenWidth * 0.8)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        _ = authorLabel.then {
                   $0.set(text: "诗人，海子", size: 10)
                   $0.textColor = UIColor(hexString: "ffffff", alpha: 0.8)
                   view.addSubview($0)
                   $0.snp.makeConstraints {
                    $0.top.equalTo(mottoLabel.snp.bottom).offset(16)
                       $0.right.equalToSuperview().offset(-24)
                   }
               }
               
               _ = lineView.then {
                   $0.backgroundColor = UIColor(hexString: "ffffff", alpha: 0.8)
                   view.addSubview($0)
                   $0.snp.makeConstraints {
                       $0.centerY.equalTo(authorLabel)
                       $0.right.equalTo(authorLabel.snp.left).offset(-10)
                       $0.width.equalTo(64)
                       $0.height.equalTo(1)
                   }
               }
               
    }
    
    func setupDate() {
        _ = dayLabel.then {
            $0.text = "02"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 50)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(8)
            }
        }
        
        _ = dateLine.then {
            $0.backgroundColor = UIColor(hexString: "ffffff", alpha: 0.4)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(dayLabel)
                $0.height.equalTo(44)
                $0.width.equalTo(1)
                $0.right.equalTo(dayLabel.snp.left).offset(-8)
            }
        }
        
        _ = weekLabel.then {
            $0.text = "星期日"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 12)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(dateLine.snp.left).offset(-8)
                $0.top.equalTo(dateLine)
            }
        }
        
        _ = dateLabel.then {
            $0.text = "July 2020"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 12)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(dateLine.snp.left).offset(-8)
                $0.bottom.equalTo(dateLine)
            }
        }
    }
    
    func setupBack() {
        _ = bgImage.then {
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = bgMask.then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_today_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(16)
                $0.left.equalToSuperview().offset(8)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
