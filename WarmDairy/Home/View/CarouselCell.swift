//
//  CarouselCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher
import SwiftDate

class CarouselCell: FSPagerViewCell {
    static let identifier = "CarouselCell_ID"
    
    var mottoData: MottoModel?
    
    lazy var container = UIView()
    lazy var bgImage = UIImageView()
    lazy var imageMaskView = UIView()
    lazy var dayLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var mottoLabel = UILabel()
    lazy var authorLabel = UILabel()
    lazy var lineView = UIView()
    
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
    
    func initData(mottoData: MottoModel) {
        self.mottoData = mottoData
        self.bgImage.kf.setImage(with: URL(string: mottoData.imageURL), options: [
            .transition(.fade(0.8)),
        ])
        self.authorLabel.text = mottoData.author
        self.mottoLabel.text = mottoData.motto
        self.dayLabel.text = mottoData.date.day < 10 ? "0\(mottoData.date.day)" : "\(mottoData.date.day)"
//        self.dateLabel.text = mottoData.date.toFormat("MMM yyyy")
        self.dateLabel.text = Date().toFormat("MMM yyyy HH:mm:ss")
    }
}，

extension CarouselCell {
    func setupUI() {
        
        _ = container.then {
            $0.layer.cornerRadius = 28
            $0.clipsToBounds = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = bgImage.then {
            $0.contentMode = .scaleAspectFill
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = imageMaskView.then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = dayLabel.then {
            $0.textColor = UIColor(hexString: "ffffff")
            $0.font = UIFont.systemFont(ofSize: 32)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(24)
            }
        }
        
        _ = dateLabel.then {
            $0.textColor = UIColor(hexString: "ffffff")
            $0.font = UIFont.systemFont(ofSize: 10)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(dayLabel)
                $0.top.equalTo(dayLabel.snp.bottom).offset(8)
            }
        }
        
        _ = authorLabel.then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor(hexString: "ffffff", alpha: 0.8)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-40)
                $0.right.equalToSuperview().offset(-20)
            }
        }
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(hexString: "ffffff", alpha: 0.8)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(authorLabel)
                $0.right.equalTo(authorLabel.snp.left).offset(-10)
                $0.width.equalTo(64)
                $0.height.equalTo(1)
            }
        }
        
        _ = mottoLabel.then {
            $0.textColor = UIColor(hexString: "ffffff")
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.preferredMaxLayoutWidth = CarouselFrameModel.cellWidth - 40
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.right
                    .equalToSuperview().offset(-20)
                $0.bottom.equalTo(authorLabel
                    .snp.top).offset(-16)
            }
        }
    }
}
