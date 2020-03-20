//
//  MeViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var bgImage = UIImageView()
    
    lazy var userContainer = UIView()
    lazy var avatarImageView = UIImageView()
    lazy var usernameLabel = UILabel()
    lazy var userMottolLabel = UILabel()
    
    lazy var allDairyLabel = UILabel()
    lazy var recordTimeLabel = UILabel()
    lazy var continousCreateLabel = UILabel()
    
    lazy var premiumView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension MeViewController {
    func setupUI() {
        setBackgroud()
        setupUser()
        setupRecord()
        setupPremiumView()
    }
    
    func setupPremiumView() {
        let premiumView = UIView().then {
            $0.layer.cornerRadius = 6
                       $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.top.equalTo(userContainer.snp.bottom).offset(16)
                $0.height.equalTo(64)
            }
        }
        _ = UIImageView().then {
            $0.image = R.image.image_me_bg()
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
//        _ = UIVisualEffectView().then {
//            $0.effect = UIBlurEffect(style: .light)
//            premiumView.addSubview($0)
//            $0.snp.makeConstraints {
//                $0.edges.equalToSuperview()
//            }
//        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.5)
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let image = UIImageView().then {
            $0.image = R.image.icon_me_premium()
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(28)
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview().offset(-50)
            }
        }
        _ = UILabel().then {
            $0.text = "解锁专业版"
            $0.textColor = UIColor(hexString: "F4C204")
            $0.font = UIFont.systemFont(ofSize: 20)
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(image.snp.right).offset(8)
            }
        }
    }
    
    func setupRecord() {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.top.equalTo(bgImage.snp.bottom).offset(20)
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        func generateItemStack(label: UILabel, text: String) -> UIStackView {
            let itemStack = UIStackView().then {
                $0.axis = .vertical
                $0.distribution = .fillProportionally
                $0.spacing = 4
            }
            label.textColor = UIColor(hexString: "303133")
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            itemStack.addArrangedSubview(label)
            _ = UILabel().then {
                $0.text = text
                $0.textColor = UIColor(hexString: "454B51")
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textAlignment = .center
                itemStack.addArrangedSubview($0)
            }
            return itemStack
        }
        
        _ = allDairyLabel.then {
            $0.text = "123篇"
        }
        
        _ = recordTimeLabel.then {
            $0.text = "320小时20分"
        }
        
        _ = continousCreateLabel.then {
            $0.text = "32天"
            
        }
        
        stackView.addArrangedSubview(generateItemStack(label: allDairyLabel, text: "所有日记"))
        stackView.addArrangedSubview(generateItemStack(label: recordTimeLabel, text: "记录时长"))
        stackView.addArrangedSubview(generateItemStack(label: continousCreateLabel, text: "连续创作"))
        
    }
    
    func setupUser() {
        _ = userContainer.then {
            $0.backgroundColor = UIColor(hexString: "FEFFFF", alpha: 0.8)
            $0.layer.cornerRadius = 6
            $0.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.height.equalTo(180)
                $0.top.equalTo(bgImage.snp.bottom).offset(-90)
            }
        }
        
        _ = avatarImageView.then {
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
            $0.image = R.image.test()
            $0.contentMode = .scaleAspectFill
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.top.equalToSuperview().offset(-16)
                $0.width.height.equalTo(84)
            }
        }
        
        _ = usernameLabel.then {
            $0.text = "Silence"
            $0.textColor = UIColor(hexString: "161A1A")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(6)
                $0.left.equalTo(avatarImageView.snp.right).offset(12)
            }
        }
        
        _ = userMottolLabel.then {
            $0.text = "世界美好与你环环相扣，你也不必牵强，慢慢的凋落。"
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(usernameLabel)
                $0.top.equalTo(usernameLabel.snp.bottom).offset(6)
                $0.right.equalToSuperview().offset(-12)
            }
        }
    }
    
    func setBackgroud() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
        
        _ = bgImage.then {
            $0.image = R.image.image_me_bg()
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(-DeviceInfo.topSafeAreaHeight)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(DeviceInfo.topSafeAreaHeight + 200)
            }
        }
    }
}
