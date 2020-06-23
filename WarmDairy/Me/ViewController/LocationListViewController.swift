//
//  LocationListViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyUserDefaults

protocol LocationListDelegate {
    func chooseLocation(id: String) -> Void
}

class LocationListViewController: UIViewController {
    
    lazy var locations = [LocationModel]()
    
    var delegate: LocationListDelegate?
    
    var mreader: DUAReader?
    
    /// 是否是present出来的
    var isPresented = true
    /// 进来的时候是否隐藏了tabbar
    var isHideTabbar = false
    /// 是否是编辑器里选择地点的
    var isChooseLocation = false
    /// 当前选择的位置id
    var currentChoosedId: Int = 0
    
    lazy var navbar = CustomNavigationBar()
    lazy var locationListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .locationDidChanged, object: nil)
        setupUI()
        loadData()
    }
    
    func initData(isPresented: Bool = true, isHideTabbar: Bool = false, isChooseLocation: Bool = false, currentChoosedId: String = "") {
        self.isPresented = isPresented
        self.isHideTabbar = isHideTabbar
        self.isChooseLocation = isChooseLocation
        self.currentChoosedId = Int(currentChoosedId) ?? 0
    }
    
    @objc func loadData() {
        LocationAPI.getLocations { [weak self] (locations) in
            guard let self = self else { return }
            self.locations = locations
            self.locationListTableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .locationDidChanged, object: nil)
    }
}

extension LocationListViewController {
    func goBack() {
        if isHideTabbar {
            (navigationController?.tabBarController as? TabBarViewController)?.showTabbar()
        }
        
        if self.isPresented {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addMoreLocation() {
        AnalysisTool.shared.logEvent(event: "位置-添加位置按钮点击")
        if !Defaults[.isVIP] {
            if locations.count >= VIPModel.locationCount {
                let vc = SubscriptionViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                return
            }
        }
        
        let vc = AddLocationViewController()
        vc.initData(isPresented: isPresented)
        if isPresented {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LocationListViewController: LocationCellDelegate {
    func locationCellMoreButtonClicked(index: Int) {
        AnalysisTool.shared.logEvent(event: "位置-更多按钮点击")
        let alert = UIAlertController(title: "编辑位置 \(locations[index].name)", message: "\(locations[index].address)", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "删除", style: .destructive) { [weak self] (action) in
            self?.deleteLocation(index: index)
        }
        let ok = UIAlertAction(title: "编辑", style: .default, handler: {
            [weak self] action in
            self?.editLocation(index: index)
        })
        
        if DeviceInfo.isiPad {
            let popover = alert.popoverPresentationController
            if let popover = popover {
                popover.barButtonItem = self.navigationItem.rightBarButtonItem
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0, y: DeviceInfo.screenHeight, width: DeviceInfo.screenWidth, height: 360)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func editLocation(index: Int) {
        AnalysisTool.shared.logEvent(event: "位置-编辑位置点击")
        let vc = AddLocationViewController()
        vc.initData(isPresented: isPresented, location: locations[index])
        if isPresented {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteLocation(index: Int) {
        AnalysisTool.shared.logEvent(event: "位置-删除位置点击")
        let alert = UIAlertController(title: "删除位置 \(locations[index].name)", message: locations[index].address, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "删除", style: .destructive, handler: {
            [weak self] ACTION in
            guard let self = self else { return }
            LocationAPI.deleteLocation(id: self.locations[index].id) { (isDeleted) in
                MessageTool.shared.showMessage(title: "删除成功")
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - delegate
extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (rowAction, indexPath) in
            self?.deleteLocation(index: indexPath.row)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { [weak self] (rowAction, indexPath) in
            self?.editLocation(index: indexPath.row)
        }
        
        editAction.backgroundColor = UIColor(hexString: "0CC4C4")
        
        return [deleteAction, editAction]
    }
}
extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListCell.identifier, for: indexPath) as! LocationListCell
        cell.delegate = self
        cell.initData(location: locations[indexPath.row], index: indexPath.row, isChooseLocation: isChooseLocation, selectedId: currentChoosedId)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AnalysisTool.shared.logEvent(event: "位置-查看日记cell点击")
        if isChooseLocation {
            if currentChoosedId == locations[indexPath.row].id {
                currentChoosedId = 0
                delegate?.chooseLocation(id: "")
            } else {
                currentChoosedId = locations[indexPath.row].id
                delegate?.chooseLocation(id: "\(currentChoosedId)")
            }
            locationListTableView.reloadData()
        } else {
            DairyAPI.getDairy(locationId: locations[indexPath.row].id) { [weak self](dairies) in
                if dairies.count == 0 {
                    MessageTool.shared.showMessage(theme: .error, title: "当前位置还没有日记")
                } else {
                    self?.setupReader(dairies: dairies)
                }
            }
        }
    }
}

extension LocationListViewController {
    func setupUI() {
        setupNav()
        setupTable()
    }
    
    func setupTable() {
        _ = locationListTableView.then {
            $0.tableHeaderView?.height = 0
            $0.backgroundColor = .clear
            $0.separatorColor = .clear
            $0.rowHeight = 64
            $0.delegate = self
            $0.dataSource = self
            
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(navbar.snp.bottom)
            }
            $0.register(LocationListCell.self, forCellReuseIdentifier: LocationListCell.identifier)
        }
    }
    
    func setupNav() {
        view.backgroundColor = UIColor(hexString: "f1f6fa")
        
        _ = navbar.then {
            $0.initData(title: "位置", rightText: "添加") { [weak self] in
                self?.goBack()
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        navbar.rightButton.addTarget(self, action: #selector(addMoreLocation), for: .touchUpInside)
    }
}

extension LocationListViewController {
    func setupReader(dairies: [DairyModel], url: String = "") {
        
        /// 将 dairies 的 图片 地址 替换
        let hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub.mode = .indeterminate
        hub.animationType = .fade
        hub.show(animated: true)
        
        let newDiaries = DairyAPI.formatDairyImagePath(dairies: dairies)
        
        hub.hide(animated: true)
        
        mreader = DUAReader()
        let configuration = DUAConfiguration()
        
        if url == "" {
            configuration.backgroundImage = R.image.image_editor_bg()
        } else {
            if let imageUrl = URL(string: url) {
                let data = NSData(contentsOf: imageUrl)
                if let imageData = data {
                    configuration.backgroundImage = UIImage(data: imageData as Data)
                } else {
                    configuration.backgroundImage =  R.image.image_editor_bg()
                }
            } else {
                configuration.backgroundImage =  R.image.image_editor_bg()
            }
        }
        configuration.bookType = .epub
        configuration.backgroundColor = .yellow
        mreader?.config = configuration
        mreader?.delegate = self
        mreader?.modalPresentationStyle = .fullScreen
        present(mreader!, animated: true, completion: nil)
        
        mreader?.readWith(dairies: newDiaries, pageIndex: 1)
        mreader?.setupUI()
    }
}

extension LocationListViewController: DUAReaderDelegate {
    func readerDidClickSettingFrame(reader: DUAReader) {
        if reader.bottomBar.alpha == 0 {
            reader.showBar()
        } else {
            reader.hideBar()
        }
    }
    
    func reader(reader: DUAReader, readerStateChanged state: DUAReaderState) {
        
    }
    
    func reader(reader: DUAReader, readerProgressUpdated curChapter: Int, curPage: Int, totalPages: Int) {
        
    }
    
    func reader(reader: DUAReader, chapterTitles: [String]) {
        
    }
    
}
