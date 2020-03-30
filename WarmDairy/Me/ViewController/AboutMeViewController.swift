//
//  AboutMeViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/28.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
    
    lazy var navbar = CustomNavigationBar()
    
    lazy var logoImage = UIImageView()
    lazy var logoTitle = UILabel()
    lazy var descriptionStr = UILabel()
    lazy var version = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension AboutMeViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = navbar.then {
            $0.initData(title: "关于我们") { [weak self] in self?.navigationController?.popViewController(animated: true)
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        _ = logoTitle.then {
            $0.text = "Warm Diary"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont(name: FontName.DS.medium.rawValue, size: 36)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
        
        let logoView = UIView().then {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.snp.centerY).offset(-50)
                $0.width.height.equalTo(96)
            }
        }
        
        _ = logoImage.then {
            $0.image = R.image.logo()
            $0.contentMode = .scaleAspectFill
            logoView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = descriptionStr.then {
            $0.text = "满地都是六便士，他却抬头看见了月亮。"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(logoTitle.snp.bottom).offset(24)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(DeviceInfo.screenWidth - 48)
            }
        }
        
        _ = version.then {
            $0.text = "Warm Diary - V1.0"
            $0.textColor = UIColor(hexString: "909399")
            $0.font = UIFont.systemFont(ofSize: 12)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(descriptionStr.snp.bottom).offset(64)
            }
        }
    }
}
