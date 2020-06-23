//
//  CategoryChooserCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/28.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

protocol CategoryChooserCellDelegate {
    func moreButtonClicked(index: Int) -> Void
}

class CategoryChooserCell: UITableViewCell {
    
    static let identifier = "CategoryChooserCell_ID"
    var delegate: CategoryChooserCellDelegate?
    
    lazy var cateLabel = UILabel()
    lazy var checkImage = UIImageView()
    lazy var moreButton = UIButton()
    
    var cellIndex = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(cate: String, isSelected: Bool, index: Int) {
        cateLabel.text = cate
        cellIndex = index
        if isSelected {
            cateLabel.textColor = UIColor(hexString: "27B755")
            checkImage.image = R.image.icon_subcription_check()
        } else {
            cateLabel.textColor = UIColor(hexString: "303133")
            checkImage.image = R.image.icon_category_check()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImage.image = nil
        cateLabel.textColor = UIColor(hexString: "303133")
    }
}

extension CategoryChooserCell {
    @objc func moreButtonClicked() {
        delegate?.moreButtonClicked(index: cellIndex)
    }
}

extension CategoryChooserCell {
    func setupUI() {
        backgroundColor = .clear
        
        _ = cateLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            if DeviceInfo.isiPad {
                $0.textAlignment = .center
            }
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(60)
                $0.right.equalToSuperview().offset(-70)
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = checkImage.then {
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(18)
                $0.width.height.equalTo(26)
            }
        }
        
        _ = moreButton.then {
            $0.setImage(R.image.icon_location_more(), for: .normal)
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
                $0.right.equalToSuperview().offset(-12)
                $0.centerY.equalToSuperview()
            }
            $0.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "dddddd")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

