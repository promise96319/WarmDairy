//
//  AddLocationViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    var isPresented: Bool = true
    
    var isGetCurrentPosition: Bool = false
    
    lazy var navbar = CustomNavigationBar()
    
    lazy var autoLocationContainer = UIView()
    lazy var autoLocationCell = SettingCell()
    lazy var autoLocationNameCell = SettingCell()
    lazy var autoSaveButton = UIButton()
    
    lazy var manualLocationContainer = UIView()
    lazy var manualLocationCell = SettingCell()
    lazy var manualLocationNameCell = SettingCell()
    lazy var manualSaveButton = UIButton()
    
    var autoLocation = LocationModel()
    var manualLocation = LocationModel()
    
    enum Placeholder: String {
        case locating = "正在定位..."
        case locateFail = "定位失败"
        case name = "请输入位置别名"
        case location = "请输入准确的地理位置"
    }
    
    enum LocationType {
        case auto
        case manual
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCurrentLocation()
    }
    
    func initData(isPresented: Bool = true, location: LocationModel? = nil) {
        self.isPresented = isPresented
        
        if let location = location {
            manualLocation.id = location.id
            manualLocation.name = location.name
            manualLocation.address = location.address
            manualLocation.latitude = location.latitude
            manualLocation.longitude = location.longitude
            autoLocation.id = location.id
            autoLocation.name = location.name
            
            autoLocationNameCell.rightLabel.text = location.name
            manualLocationNameCell.rightLabel.text = location.name
            manualLocationCell.rightLabel.text = location.address
        }
    }
}

extension AddLocationViewController: DiaryLocationDelegate {
    func onGeoCodeSearchDone(latitude: CGFloat?, longitude: CGFloat?) {
        if let latitude = latitude, let longitude = longitude {
            manualLocation.latitude = latitude
            manualLocation.longitude = longitude
            LocationAPI.saveLocations(location: manualLocation) { (isSaved) in
                if isSaved {
                    DispatchQueue.main.async { [weak self] in
                        MessageTool.shared.showMessage(title: "保存成功")
                        self?.goBack()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                MessageTool.shared.showMessage(theme: .error, title: "无法定位", body: "请检查您输入的地理位置是否有误", duration: 3)
            }
        }
    }
}

// MARK: - 事件处理
extension AddLocationViewController {
    func goBack() {
        if isPresented {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func getCurrentLocation() {
        if autoLocation.address != "" { return }
        let (isAuth, alert) = DiaryLocationManager.shared.checkAuth()
        if !isAuth {
            if let alert = alert {
                present(alert, animated: true, completion: nil)
            }
            return
        }
        
        if isGetCurrentPosition { return }
        isGetCurrentPosition = true
        autoLocationCell.rightLabel.text = Placeholder.locating.rawValue
        DiaryLocationManager.shared.getCurrentPosition() { [weak self] (location, code, error) in
            self?.isGetCurrentPosition = false
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.autoLocationCell.rightLabel.text = Placeholder.locateFail.rawValue
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.autoLocationCell.rightLabel.text = code?.formattedAddress
                self?.autoLocation.address = code?.formattedAddress ?? ""
                self?.autoLocation.latitude = CGFloat(location?.coordinate.latitude ?? 0)
                self?.autoLocation.longitude = CGFloat(location?.coordinate.longitude ?? 0)
            }
        }
    }
    
    func customLocation() {
        let alert = UIAlertController(title: "自定义位置", message: "请按省/市/区/街道/具体位置的格式填写，以便提高定位的准确度", preferredStyle: .alert)
        alert.addTextField { [weak self] (field) in
            guard let self = self else { return }
            field.text = self.manualLocation.address
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "保存", style: .default, handler: {
            [weak self] ACTION in
            guard let self = self else { return }
            guard let text = alert.textFields?.first?.text else { return }
            if text == "" { return }
            self.manualLocationCell.rightLabel.text = text
            self.manualLocation.address = text
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    /// 输入位置别名
    /// - Parameter type: 类型 auto | manual
    func editLocationName(type: LocationType = .auto) {
        let alert = UIAlertController(title: "位置别名", message: "", preferredStyle: .alert)
        alert.addTextField { [weak self] (field) in
            guard let self = self else { return }
            if type == .auto {
                if self.autoLocation.name != Placeholder.name.rawValue {
                    field.text = self.autoLocation.name
                }
            } else {
                if self.manualLocation.name != Placeholder.name.rawValue {
                    field.text = self.manualLocation.name
                }
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "保存", style: .default, handler: {
            [weak self] ACTION in
            guard let self = self else { return }
            guard let text = alert.textFields?.first?.text else { return }
            if text == "" { return }
            if type == .auto {
                self.autoLocation.name = text
                self.autoLocationNameCell.rightLabel.text = text
            } else {
                self.manualLocation.name = text
                self.manualLocationNameCell.rightLabel.text = text
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveAutoLocation() {
        if isGetCurrentPosition {
            MessageTool.shared.showMessage(theme: .warning, title: "正在定位...", body: "请耐心等待~")
            return
        }
        
        if autoLocation.address == "" {
            MessageTool.shared.showMessage(theme: .error, title: "当前定位失败，无法保存。")
            return
        }
        
        LocationAPI.saveLocations(location: autoLocation) { [weak self] (isSaved) in
            if isSaved {
                MessageTool.shared.showMessage(title: "保存成功！")
                self?.goBack()
            }
        }
    }
    
    @objc func saveManualLocation() {
        if manualLocation.address == "" {
            MessageTool.shared.showMessage(theme: .warning, title: "请输入您的具体位置。")
            return
        }
        
        CLog("manualLocation的值为: \(manualLocation)")
        
        DiaryLocationManager.shared.delegate = self
        DiaryLocationManager.shared.getGeocodeCoordirateFromAddress(address: manualLocation.address)
    }
}

// MARK: - UI界面
extension AddLocationViewController {
    func setupUI() {
        setupNav()
        setupAuto()
        setupManual()
    }
    
    func setupAuto() {
        _ = autoLocationContainer.then {
            addBg(view: $0)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(navbar.snp.bottom).offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(3 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
            }
            
            for (index, cell) in [autoLocationCell, autoLocationNameCell].enumerated() {
                _ = cell.then {
                    autoLocationContainer.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.left.right.equalToSuperview()
                        $0.height.equalTo(SettingCellModel.cellHeight)
                        $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                    }
                }
            }
            
            autoLocationCell.initData(leftText: "当前定位", rightText: Placeholder.locateFail.rawValue) { [weak self] in
                self?.getCurrentLocation()
            }
            
            let name = autoLocation.name == "" ? Placeholder.name.rawValue : autoLocation.name
            autoLocationNameCell.initData(leftText: "位置别名", rightText: name) { [weak self] in
                self?.editLocationName()
            }
            
            _ = autoSaveButton.then {
                $0.backgroundColor = UIColor(hexString: "0CC4C4")
                $0.layer.cornerRadius = 22
                $0.setTitle("保存", for: .normal)
                $0.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                autoLocationContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.height.equalTo(44)
                    $0.top.equalTo(autoLocationNameCell.snp.bottom).offset(14)
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(160)
                }
                $0.addTarget(self, action: #selector(saveAutoLocation), for: .touchUpInside)
            }
        }
    }
    
    func setupManual() {
        _ = manualLocationContainer.then {
            addBg(view: $0)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(autoLocationContainer.snp.bottom).offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(3 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
            }
            
            for (index, cell) in [manualLocationCell, manualLocationNameCell].enumerated() {
                _ = cell.then {
                    manualLocationContainer.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.left.right.equalToSuperview()
                        $0.height.equalTo(SettingCellModel.cellHeight)
                        $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                    }
                }
            }
            
            let address = manualLocation.address == "" ? Placeholder.location.rawValue : manualLocation.address
            manualLocationCell.initData(leftText: "自定义位置", rightText: address) { [weak self] in
                self?.customLocation()
            }
            
            let name = manualLocation.name == "" ? Placeholder.name.rawValue : manualLocation.name
            manualLocationNameCell.initData(leftText: "位置别名", rightText: name) { [weak self] in
                self?.editLocationName(type: .manual)
            }
            
            _ = manualSaveButton.then {
                $0.backgroundColor = UIColor(hexString: "0CC4C4")
                $0.layer.cornerRadius = 22
                $0.setTitle("保存", for: .normal)
                $0.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                manualLocationContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.height.equalTo(44)
                    $0.top.equalTo(manualLocationNameCell.snp.bottom).offset(14)
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(160)
                }
                $0.addTarget(self, action: #selector(saveManualLocation), for: .touchUpInside)
            }
        }
    }
    
    func setupNav() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = navbar.then {
            $0.initData(title: "位置") { [weak self] in
                self?.goBack()
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
    }
    
    func addBg(view: UIView) {
        view.backgroundColor = UIColor(hexString: "FEFFFF", alpha: 0.8)
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
