//
//  CustomNavigationBar.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/27.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {
    
    static let height = 54
    lazy var hearerContainer = UIView()
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton()
    lazy var rightButton = UIButton()
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(title: String, isPresent: Bool = false, rightText: String? = nil, action: @escaping () -> Void) {
        titleLabel.text = title
        self.action = action
        
        if let rightText = rightText {
            _ = rightButton.then {
                $0.setTitle(rightText, for: .normal)
                $0.setTitleColor(UIColor(hexString: "606266"), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.right.equalToSuperview().offset(-24)
                    $0.centerY.equalTo(titleLabel)
                }
            }
        }
    }
}

extension CustomNavigationBar {
    @objc func goBack() {
        if let action = action {
            action()
        }
    }
}

extension CustomNavigationBar {
    func setupUI() {
        _ = hearerContainer.then {
            $0.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.backgroundColor = UIColor(hexString: "F1F6FA")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            hearerContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-14)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            hearerContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(10)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
