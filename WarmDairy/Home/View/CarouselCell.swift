//
//  CarouselCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import FSPagerView

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
    
    func initData(mottoData: MottoModel, index: Int) {
        self.mottoData = mottoData
        self.bgImage.image = UIImage(named: "image_home_cr\(index + 1)")
    }
}

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
            $0.set(text: "02", size: 32, color: "ffffff")
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(24)
            }
        }
        
        _ = dateLabel.then {
            $0.set(text: "July 2020", size: 10, color: "ffffff")
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(dayLabel)
                $0.top.equalTo(dayLabel.snp.bottom).offset(8)
            }
        }
        
        _ = authorLabel.then {
            $0.set(text: "诗人，海子", size: 12)
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
            $0.set(text: "活在这珍贵的世间，太阳强烈，水波温柔。", color: "FFFFFF")
            $0.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
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
