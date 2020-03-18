//
//  DatePicker.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/17.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftDate

class DatePicker: UIView {
    
    weak var delegate: EditorViewController?
    
    var currentDate: Date = Date()
    
    lazy var titleLabel = UILabel()
    lazy var datePicker = UIDatePicker()
    lazy var cancelButton = UIButton()
    lazy var confirmButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(date: Date) {
        currentDate = date
        titleLabel.text = "日记日期 - \(date.year)年"
        datePicker.date = currentDate
    }
}

extension DatePicker {
    @objc func selectDate(sender: UIDatePicker) {
        let date = sender.date + 8.hours
        titleLabel.text = "日记日期 - \(date.year)年"
        currentDate = date
    }
    
    @objc func confirm() {
        delegate?.chooseDate(date: currentDate)
    }
    
    @objc func cancel() {
        delegate?.hideDatePicker()
    }
}

extension DatePicker {
    func setupUI() {
        backgroundColor = UIColor(hexString: "F1F6FA")
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 16
        
        _ = titleLabel.then {
            $0.text = "日记日期 - \(currentDate.year)年"
            $0.textColor = UIColor(hexString: "303133")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(24)
            }
        }
        
        _ = datePicker.then {
            $0.datePickerMode = .dateAndTime
            $0.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
            $0.date = currentDate
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(DeviceInfo.screenWidth - 72)
            }
            $0.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        }
        
        _ = confirmButton.then {
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(40)
                $0.bottom.equalToSuperview().offset(-16)
            }
            $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        }
        
        _ = cancelButton.then {
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(UIColor(hexString: "606266"), for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(-40)
                $0.bottom.equalToSuperview().offset(-16)
            }
            $0.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        }
    }
}
