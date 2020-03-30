//
//  CategoryChooserCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/28.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

// MARK: - 分类cell
class CategoryChooserCell: UICollectionViewCell {
    static let identifier = "CategoryChooserCell_ID"
    lazy var cateLabel = UILabel()
    lazy var checkImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(cate: String, isSelected: Bool) {
        cateLabel.text = cate
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
    func setupUI() {
        _ = cateLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            if DeviceInfo.isiPad {
                $0.textAlignment = .center
            }
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview().offset(-30)
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = checkImage.then {
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.width.height.equalTo(26)
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "c4c4c4")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

