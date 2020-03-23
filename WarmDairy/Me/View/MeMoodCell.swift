//
//  MeMoodCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class MeMoodCell: UICollectionViewCell {
    static let identifier = "MeMoodCell_ID"
    var moodHeight: CGFloat = 0
    
    lazy var titleLabel = UILabel()
    lazy var heightView = UIView()
    lazy var moodImage = UIImageView()
    lazy var moodCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(moodHeight: CGFloat, mood: MoodModel) {
        self.moodHeight = moodHeight
        titleLabel.text = mood.title
        moodImage.image = UIImage(named: "icon_mood_\(mood.image)")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        moodCountLabel.text = "x\(mood.dairyCount)"
        heightView.backgroundColor = UIColor(hexString: mood.color)
        heightView.snp.makeConstraints {
            $0.height.equalTo(moodHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
            $0.width.equalTo(36)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heightView.snp.removeConstraints()
    }
}

extension MeMoodCell {
    func setupUI() {
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 12)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        }
        
        _ = heightView.then {
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hexString: "909399")?.cgColor
            addSubview($0)
        }
        
        _ = moodImage.then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(50)
                $0.centerX.equalToSuperview().offset(-4)
                $0.bottom.equalTo(heightView.snp.top).offset(2)
            }
        }
        
        _ = moodCountLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 12)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(moodImage.snp.right).offset(-8)
                $0.bottom.equalTo(moodImage).offset(-10)
            }
        }
    }
}
