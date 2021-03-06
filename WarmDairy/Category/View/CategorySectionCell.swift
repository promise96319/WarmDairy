//
//  CategorySectionCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CategorySectionCell: UICollectionViewCell {
    static let identifier = "CategorySectionCell_ID"
    
    lazy var bgImage = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var countLabel = UILabel()
    lazy var moreButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moreButton.isHidden = true
    }
    
    func initData(monthData: CategoryMonthModel) {
        bgImage.kf.setImage(with: URL(string: monthData.image))
        let monthsName = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"]
        titleLabel.text = "\(monthsName[monthData.month - 1])月"
        countLabel.text = "\(monthData.dairies.count)篇日记"
    }
    
    func initFavoriteData(data: CustomCategoryModel) {
        titleLabel.text = data.name
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        countLabel.text = "\(data.dairies.count)篇日记"
        moreButton.isHidden = false
        bgImage.kf.setImage(with: URL(string: data.image))
    }
}

extension CategorySectionCell {
    func setupUI() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 4
        setupBackground()
        setupContent()
    }
    
    func setupContent() {
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "ffffff")
            $0.font = UIFont.systemFont(ofSize: 28)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(8)
                $0.right.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview().offset(-16)
            }
        }
        
        _ = moreButton.then {
            $0.isHidden = true
            $0.setImage(R.image.icon_category_more(), for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
                $0.top.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }
        
        _ = countLabel.then {
            $0.textColor = UIColor(hexString: "ffffff", alpha: 0.8)
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            }
        }
    }
    
    func setupBackground() {
        _ = bgImage.then {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            bgImage.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
