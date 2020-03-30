//
//  SettingCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class SettingCell: UIView {
    
    lazy var leftLabel = UILabel()
    lazy var rightLabel = UILabel()
    lazy var rightArrowIcon = UIImageView()
    lazy var rightSwitch = UISwitch()
    lazy var avatarImage = UIImageView()
    
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(leftText: String,
                  rightText: String? = nil,
                  isBorder: Bool = true,
                  avatar: CreamAsset? = nil,
                  isRightArrowIcon: Bool = false,
                  isRightSwitch: Bool = false,
                  callback: @escaping () -> Void) {
        self.action = callback
        leftLabel.text = leftText
        
        if isRightSwitch {
            rightSwitch.isHidden = false
        }
        
        if rightText != nil {
            rightLabel.isHidden = false
            rightLabel.text = rightText
        }
        
        if let data = avatar?.storedData() {
            avatarImage.isHidden = false
            avatarImage.image = UIImage(data: data)
        }
        
        if isBorder {
            _ = UIView().then {
                $0.backgroundColor = UIColor(hexString: "eeeeee")
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.left.equalToSuperview().offset(24)
                    $0.right.equalToSuperview().offset(-24)
                    $0.height.equalTo(1)
                }
            }
        }
        
        if isRightArrowIcon {
            rightArrowIcon.isHidden = false
        }
    }
}

extension SettingCell {
    @objc func cellClick() {
        if let action = action {
            action()
        }
    }
}

extension SettingCell {
    func setupUI() {
        _ = leftLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(24)
            }
        }
        
        setupRightLabel()
        setupAvatar()
        setupRightArrorIcon()
        setupSwitch()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellClick))
        self.addGestureRecognizer(tap)
    }
    
    func setupSwitch() {
        _ = rightSwitch.then {
            $0.isHidden = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-24)
            }
        }
    }
    
    func setupAvatar() {
        _ = avatarImage.then {
            $0.isHidden = true
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = 6
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(54)
                $0.right.equalToSuperview().offset(-24)
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            addSubview($0)
            avatarImage.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = UIImageView().then {
            $0.image = R.image.icon_me_camera()
            $0.isUserInteractionEnabled = true
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            avatarImage.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(44)
            }
        }
    }
    
    func setupRightLabel() {
        _ = rightLabel.then {
            $0.isHidden = true
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .right
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-24)
                $0.width.equalTo(DeviceInfo.screenWidth * 0.6)
            }
        }
    }
    
    func setupRightArrorIcon() {
        _ = rightArrowIcon.then {
            $0.isHidden = true
            $0.image = R.image.icon_me_arrow_right()?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor(hexString: "c0c4cc")
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-14)
                $0.width.height.equalTo(44)
            }
        }
    }
}
