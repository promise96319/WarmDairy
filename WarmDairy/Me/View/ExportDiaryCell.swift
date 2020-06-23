//
//  ExportDiaryCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class ExportDiaryCell: UITableViewCell {
    
    static let identifier = "ExportDiaryCell_ID"
    
    lazy var titleLabel = UILabel()
    lazy var diaryCountLabel = UILabel()
    lazy var checkImage = UIImageView()
    
    lazy var locationNameLabel = UILabel()
    lazy var locationAddressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(count: Int, isChecked: Bool = false, title: String? = nil, name: String? = nil, address: String? = nil) {
        diaryCountLabel.text = "\(count)篇日记"
        checkImage.image = isChecked ? R.image.icon_subcription_check() : R.image.icon_category_check()
        if title != nil {
            titleLabel.isHidden = false
            titleLabel.text = title
        } else {
            locationNameLabel.isHidden = false
            locationAddressLabel.isHidden = false
            locationNameLabel.text = name
            locationAddressLabel.text = address
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.isHidden = true
        locationNameLabel.isHidden = true
        locationAddressLabel.isHidden = true
        checkImage.image = R.image.icon_category_check()
    }
}

extension ExportDiaryCell {
    func setupUI() {
        backgroundColor = .clear
        
        _ = titleLabel.then {
            $0.isHidden = true
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-200)
            }
        }
        
        _ = locationNameLabel.then {
            $0.isHidden = true
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-200)
            }
        }
        
        _ = locationAddressLabel.then {
            $0.isHidden = true
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 10)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(locationNameLabel)
                $0.top.equalTo(locationNameLabel.snp.bottom).offset(3)
            }
        }
        
        _ = checkImage.then {
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(26)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        _ = diaryCountLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalTo(checkImage.snp.left).offset(-16)
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "dddddd")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}

