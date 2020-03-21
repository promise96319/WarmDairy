//
//  SearchResultCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftDate

class SearchResultCell: UICollectionViewCell {
    static let identifier = "SearchResultCell_ID"
    
    lazy var lineView = UIView()
    lazy var titleLabel = UILabel()
    lazy var weatherView = UIImageView()
    lazy var moodView = UIImageView()
    lazy var dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse()
    }
    
    func initData(dairy: DairyModel) {
        titleLabel.text = dairy.title
        dateLabel.text = dairy.createdAt.toFormat("yyyy年MM月dd日") + "" +  dairy.createdAt.weekdayName(.default, locale: Locales.chineseSimplified)
        
        if dairy.mood != "" {
            _ = moodView.then {
                $0.image = UIImage(named: "icon_mood_\(dairy.mood)")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
                $0.contentMode = .scaleAspectFill
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(DairyCellFrame.headerHeight)
                    $0.centerY.equalToSuperview()
                    $0.right.equalToSuperview()
                }
            }
        }
        
        if dairy.weather != "" {
            _ = weatherView.then {
                $0.image = UIImage(named: "icon_weather_\(dairy.weather)")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
                $0.contentMode = .scaleAspectFill
                addSubview($0)
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(DairyCellFrame.headerHeight)
                    $0.centerY.equalToSuperview()
                    if dairy.mood == "" {
                        $0.right.equalToSuperview()
                    } else {
                        $0.right.equalTo(moodView.snp.left)
                    }
                }
            }
        }
    }
}

extension SearchResultCell {
    func setupUI() {
        _ = lineView.then {
            $0.backgroundColor = UIColor(hexString: "dddddd")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.right.equalToSuperview().offset(-100)
                $0.top.equalToSuperview().offset(12)
            }
        }
        
        _ = dateLabel.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 14)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-12)
                $0.left.equalToSuperview().offset(12)
            }
        }
    }
}
