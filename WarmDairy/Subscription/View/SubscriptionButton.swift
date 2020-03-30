//
//  SubscriptionButton.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/25.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class SubscriptionButton: UIView {
    
    lazy var leftText = UILabel()
    lazy var rightText = UILabel()
    
    var action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(leftText: String, rightText: String, action: @escaping () -> Void) {
        self.leftText.text = leftText
        self.rightText.text = rightText
        self.action = action
    }
}

extension SubscriptionButton {
    @objc func buttonClick() {
        if let action = action {
            action()
        }
    }
}

extension SubscriptionButton {
    func setupUI() {
        layer.cornerRadius = SubscriptionFrameModel.buttonRadius
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#FFF1CF")!.cgColor, UIColor(hexString: "#F59D3C")!.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth - 64 , height: SubscriptionFrameModel.buttonHeight)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let containerView = UIView().then {
            $0.layer.addSublayer(gradientLayer)
            $0.layer.cornerRadius = SubscriptionFrameModel.buttonRadius
            $0.clipsToBounds = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonClick))
            addGestureRecognizer(tapGesture)
        }
        
        _ = leftText.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
            containerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(128)
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = rightText.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
            containerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(80)
                $0.right.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
    }
}
