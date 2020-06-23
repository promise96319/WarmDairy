//
//  ReminderViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/6/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ReminderViewController: UIViewController {
    weak var delegate: SettingViewController?
    
    lazy var navbar = CustomNavigationBar()
    lazy var reminderSwitch = UISwitch()
    
    var hoursArray: [String] {
        var arr = [String]()
        for index in 0..<24 {
            //            let str = index < 10 ? "0\(index)" : "\(index)"
            arr.append("\(index)")
        }
        return arr
    }
    
    var minutesArray: [String] {
        var arr = [String]()
        for index in 0..<60 {
            //            let str = index < 10 ? "0\(index)" : "\(index)"
            //            arr.append(str)
            arr.append("\(index)")
        }
        return arr
    }
    
    var selectedHour: Int = Defaults[.reminderHour]
    var selectedMinute: Int = Defaults[.reminderMinute]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getAuthorizationStatus), name: NSNotification.Name(rawValue: "ApplicationDidBecomeActive"), object: nil)
        
        ReminderNotificationManager.share.authorization { [weak self] success in
            /// 通过授权结果来决定 isReminder 是否开启(界面)
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                self?.reminderSwitch.isOn = success
            })
        }
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ApplicationDidBecomeActive"), object: nil)
    }
}

// MARK: - 事件
extension ReminderViewController {
    /// 监听设置后的通知授权状态改变
    /// 1. 如果授权了，则开启闹钟提醒，并设置相关通知。
    /// 2. 如果未授权，则关闭闹钟提醒。
    @objc func getAuthorizationStatus() {
        ReminderNotificationManager.share.getAuthorizationStatus() { status in
            switch status {
            case .authorized:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                    self?.reminderSwitch.isOn = true
                    self?.setBedtimeReminder()
                })
                break
            case .denied:
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                    self?.reminderSwitch.isOn = false
                })
                break
            /// 因为每次都会请求，所以不存在not determined
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    /// 切换提醒开关：每一次开的是否需要检测是否开启了授权，如果未开启授权，则需要进入设置界面开启
    /// 监听 app become active 事件（从设置界面返回也可被监听），再一次判断是否开启了通知授权
    @objc func toggleBedtimeReminder() {
        if reminderSwitch.isOn {
            ReminderNotificationManager.share.getAuthorizationStatus { [weak self] status in
                switch status {
                case .authorized:
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                        self?.reminderSwitch.isOn = true
                    })
                    
                    self?.setBedtimeReminder()
                    break
                case .denied:
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                        let alert = UIAlertController(title: "温馨提示", message: "您还未开启通知功能，无法设置提醒", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
                        let confirm = UIAlertAction(title: "前往设置", style: .default, handler: {
                            ACTION in
                            
                            ReminderNotificationManager.share.redirectToSettings { _ in }
                        })
                        
                        alert.addAction(cancel)
                        alert.addAction(confirm)
                        self?.present(alert, animated: true, completion: nil)
                    })
                    break
                default:
                    break
                }
            }
        } else {
            ReminderNotificationManager.share.removeNotification()
            Defaults[.isReminderOn] = false
            delegate?.setReminder()
        }
    }
    
    /// 设置闹钟通知
    @objc func setBedtimeReminder() {
        ReminderNotificationManager.share.addNotification(hour: selectedHour, minute: selectedMinute)
        Defaults[.isReminderOn] = true
        Defaults[.reminderHour] = selectedHour
        Defaults[.reminderMinute] = selectedMinute
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
            self?.delegate?.setReminder()
        })
        MessageTool.shared.showMessage(theme: .success, title: "设置成功：\(selectedHour)时\(selectedMinute)分")
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursArray.count
        } else {
            return minutesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        for singleLine in pickerView.subviews {
            if singleLine.frame.size.height < 1 {
                singleLine.backgroundColor = UIColor(hexString: "303133", alpha: 0.1)
            }
        }
        
        let label = UILabel().then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        if component == 0 {
            label.text = hoursArray[row]
        } else {
            label.text = minutesArray[row]
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = Int(hoursArray[row])!
        } else {
            selectedMinute = Int(minutesArray[row])!
        }
    }
}

extension ReminderViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = navbar.then {
            $0.initData(title: "设置提醒") { [weak self] in self?.navigationController?.popViewController(animated: true)
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "开启提醒"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(navbar.snp.bottom).offset(24)
            }
        }
        
        _ = reminderSwitch.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.right.equalToSuperview().offset(-24)
            }
            $0.addTarget(self, action: #selector(toggleBedtimeReminder), for: .valueChanged)
        }

        
        _ = UILabel().then {
            $0.text = "当开启提醒的时候，温暖日记每天会按时提醒您写日记哦~"
            $0.textColor = UIColor(hexString: "303133", alpha: 0.5)
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(titleLabel)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            }
        }
        
        _ = UIButton().then {
            $0.setTitle("保存", for: .normal)
            $0.setTitleColor(UIColor(hexString: "303133"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hexString: "303133")?.cgColor
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-48)
                $0.width.equalTo(200)
                $0.height.equalTo(48)
            }
            $0.addTarget(self, action: #selector(setBedtimeReminder), for: .touchUpInside)
        }
        
        let pickerView = UIPickerView().then {
            view.addSubview($0)
            $0.dataSource = self
            $0.delegate = self
            $0.selectRow(Defaults[.reminderHour], inComponent: 0, animated: false)
            $0.selectRow(Defaults[.reminderMinute], inComponent: 1, animated: false)
            $0.snp.makeConstraints {
                $0.width.equalTo(200)
                $0.center.equalToSuperview()
            }
        }
        
        _ = UILabel().then {
            $0.backgroundColor = .clear
            $0.text = "时  "
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(pickerView)
                $0.right.equalTo(pickerView.snp.centerX)
            }
        }
        
        _ = UILabel().then {
//            $0.backgroundColor = UIColor(hexString: "")
            $0.text = "分  "
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(pickerView)
                $0.right.equalTo(pickerView)
            }
        }
    }
}
