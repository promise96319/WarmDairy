//
//  LocationListCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

protocol LocationCellDelegate {
    func locationCellMoreButtonClicked(index: Int) -> Void
}

class LocationListCell: UITableViewCell {
    
    var delegate: LocationCellDelegate?
    
    static let identifier = "LocationListCell_ID"
    
    var isChooseLocation: Bool = false
    var cellIndex: Int = 0
    
    lazy var location = LocationModel()
    lazy var locationImage = UIImageView()
    lazy var locationNameLabel = UILabel()
    lazy var locationPosition = UILabel()
    lazy var moreButton = UIButton()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(location: LocationModel, index: Int, isChooseLocation: Bool = false, selectedId: Int = 0) {
        self.location = location
        self.cellIndex = index
        
        locationNameLabel.text = location.name
        locationPosition.text = location.address
        if isChooseLocation {
            if location.id == selectedId {
                locationImage.image = R.image.icon_subcription_check()
            } else {
                locationImage.image = R.image.icon_category_check()
            }
        } else {
            locationImage.image = R.image.icon_editor_location_selected()
        }
        locationImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationImage.image = R.image.icon_category_check()
    }
}

extension LocationListCell {
    @objc func moreButtonClicked() {
        delegate?.locationCellMoreButtonClicked(index: cellIndex)
    }
}

extension LocationListCell {
    func setupUI() {
        backgroundColor = .clear
        
        _ = locationImage.then {
            $0.isHidden = true
            $0.image = R.image.icon_editor_location_selected()
            $0.contentMode = .scaleAspectFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
                $0.left.equalToSuperview().offset(18)
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = locationNameLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(70)
                $0.top.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-70)
            }
        }
        
        _ = locationPosition.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 10)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(locationNameLabel)
                $0.top.equalTo(locationNameLabel.snp.bottom).offset(3)
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
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}
