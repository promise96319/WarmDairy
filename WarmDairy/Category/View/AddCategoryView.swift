//
//  AddCategoryView.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class AddCategoryView: UIView {
    
    lazy var titleLabel = UILabel()
    lazy var textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
}

extension AddCategoryView {
    func setupUI() {
        addShadow()
        layer.cornerRadius = 12
        
        _ = titleLabel.then {
            $0.text = "新增分类"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(16)
            }
        }
        
        _ = textField.then {
            $0.placeholder = "分类名称"
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(hexString: "303133")
            $0.contentVerticalAlignment = .center
            $0.returnKeyType = .done
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            }
        }
    }
}
