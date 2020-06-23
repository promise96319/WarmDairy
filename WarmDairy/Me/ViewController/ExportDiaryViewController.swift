//
//  ExportDiaryViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class TimeSelectedIndexModel {
    var section: Int = 0
    var index: [Int] = [Int]()
}

class ExportDiaryViewController: ExportDiaryControllerDelegate {

    var isCateLoaded = false
    var isLocationLoaded = false
    var isTimeLoaded = false
    lazy var cateDiaries = [CustomCategoryModel]()
    lazy var locationDiaries = [CustomLocationModel]()
    lazy var timeDiaries = [CategoryYearModel]()
    var cateSelectedIndex = [Int]()
    var locationSelectedIndex = [Int]()
    var timeSelectedIndex = [TimeSelectedIndexModel]()
    
    lazy var navbar = CustomNavigationBar()
    var segement: UISegmentedControl!
    lazy var tableView = UITableView()
    lazy var exporButton = UIButton()
    
    var isPresented: Bool = false
    
    var currentSelectedIndex = 0
    enum ExportType: String {
        case cate = "按分类"
        case location = "按地点"
        case time = "按时间"
        
        static let all: [ExportType] = [.cate, .location, .time]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadCate()
    }
    
    func loadCate() {
        if isCateLoaded {
            tableView.reloadData()
            return
        }
        CategoryAPI.getCategoriesWithDairies { (diaries) in
            self.cateDiaries = diaries
            self.tableView.reloadData()
            self.isCateLoaded = true
        }
    }
    
    func loadLocation() {
        if isLocationLoaded {
            tableView.reloadData()
            return
        }
        LocationAPI.getLocationsWithDairies { [weak self] (diaries) in
            self?.locationDiaries = diaries
            self?.tableView.reloadData()
            self?.isLocationLoaded = true
        }
    }
    
    func loadTime() {
        if isTimeLoaded {
            tableView.reloadData()
            return
        }
        DairyAPI.getDairy() { [weak self] (dairies) in
            guard let weakSelf = self else { return }
            weakSelf.timeDiaries = CategoryViewController.formatDairies(dairies: dairies)
            self?.tableView.reloadData()
            self?.isTimeLoaded = true
        }
    }
    
    func initData(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    deinit {
        
    }
}

// MARK: - 事件处理
extension ExportDiaryViewController {
    func goBack() {
        if isPresented {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func selectSegement(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        AnalysisTool.shared.logEvent(event: "导出-选择导出-\(index)")
        currentSelectedIndex = index
        switch ExportType.all[index] {
        case .cate:
            loadCate()
        case .location:
            loadLocation()
        case .time:
            loadTime()
        }
    }
    
    @objc func exportDiaries() {
        AnalysisTool.shared.logEvent(event: "导出-导出按钮点击")
        if !Defaults[.isVIP] {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        
        var diaries = [DairyModel]()
        var filename = "Warm Diary"
        switch ExportType.all[currentSelectedIndex] {
        case .cate:
            if cateSelectedIndex.count == 0 { return }
            cateSelectedIndex = cateSelectedIndex.sorted { $0 < $1 }
            cateSelectedIndex.forEach {
                diaries += cateDiaries[$0].dairies
            }
            
            if cateSelectedIndex.count == 1 {
                filename = cateDiaries[0].name
            } else {
                filename = cateDiaries[0].name + "等\(cateSelectedIndex.count)个分类"
            }
            
            break
        case .location:
            if locationSelectedIndex.count == 0 { return }
            locationSelectedIndex = locationSelectedIndex.sorted { $0 < $1 }
            locationSelectedIndex.forEach {
                diaries += locationDiaries[$0].diaries
            }
            if locationSelectedIndex.count == 1 {
                filename = locationDiaries[0].name
            } else {
                filename = locationDiaries[0].name + "等\(locationSelectedIndex.count)个位置"
            }
            break
        case .time:
            if timeSelectedIndex.count == 0 { return }
            
            timeSelectedIndex = timeSelectedIndex.sorted { $0.section < $1.section }
            
            if timeSelectedIndex[0].index.count == 0 { return }
            
            timeSelectedIndex.forEach { (model) in
                let indexs = model.index.sorted { $0 < $1 }
                indexs.forEach { (i) in
                    diaries += timeDiaries[model.section].months[i].dairies
                }
            }
            
            if diaries.count == 0 { return }
            
            diaries = diaries.sorted { $0.createdAt < $1.createdAt }
            
            let fromDate = diaries[0].createdAt.toFormat("yyyy年MM月")
            let toDate = diaries[diaries.count - 1].createdAt.toFormat("yyyy年MM月")
            
            
            if toDate == fromDate {
                filename = toDate
            } else {
                filename = "\(fromDate)~\(toDate)"
            }
        }
        
        if diaries.count == 0 { return }
        
        exportDiariesToPDF(diaries: diaries, type: ExportType.all[currentSelectedIndex], filename: filename)
    }
}

// MARK: - delegate
extension ExportDiaryViewController: UITableViewDelegate {
}
extension ExportDiaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch ExportType.all[currentSelectedIndex] {
        case .cate, .location:
            return 1
        case .time:
            return timeDiaries.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ExportType.all[currentSelectedIndex] {
        case .cate:
            return cateDiaries.count
        case .location:
            return locationDiaries.count
        case .time:
            return timeDiaries[section].months.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExportDiaryCell.identifier, for: indexPath) as! ExportDiaryCell
        cell.selectionStyle = .none
        switch ExportType.all[currentSelectedIndex] {
        case .cate:
            let isChecked = cateSelectedIndex.contains(indexPath.row)
            cell.initData(count: cateDiaries[indexPath.row].dairies.count, isChecked: isChecked, title: cateDiaries[indexPath.row].name, name: nil, address: nil)
        case .location:
            let isChecked = locationSelectedIndex.contains(indexPath.row)
            cell.initData(count: locationDiaries[indexPath.row].diaries.count, isChecked: isChecked, title: nil, name: locationDiaries[indexPath.row].name, address: locationDiaries[indexPath.row].address)
        case .time:
            var isChecked = false
            timeSelectedIndex.forEach {
                if $0.section == indexPath.section {
                    $0.index.forEach { (index) in
                        if index == indexPath.row {
                            isChecked = true
                        }
                    }
                }
            }
            let model = timeDiaries[indexPath.section].months[indexPath.row]
            cell.initData(count: model.dairies.count, isChecked: isChecked, title: "\(model.month)月", name: nil, address: nil)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        switch ExportType.all[currentSelectedIndex] {
        case .cate:
            if cateSelectedIndex.contains(index) {
                cateSelectedIndex = cateSelectedIndex.filter { $0 != index }
            } else {
                cateSelectedIndex.append(index)
            }
            
            
            break
        case .location:
            if locationSelectedIndex.contains(index) {
                locationSelectedIndex = locationSelectedIndex.filter { $0 != index }
            } else {
                locationSelectedIndex.append(index)
            }
            break
        case .time:
            var findedSection = -1
            for (timeIndex, timeModel) in timeSelectedIndex.enumerated() {
                if timeModel.section == section {
                    findedSection = timeIndex
                    if timeModel.index.contains(index) {
                        timeModel.index = timeModel.index.filter { $0 != index }
                    } else {
                        timeModel.index.append(index)
                    }
                }
            }
            if findedSection < 0 {
                let model = TimeSelectedIndexModel()
                model.section = section
                model.index.append(index)
                timeSelectedIndex.append(model)
            }
            break
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ExportType.all[currentSelectedIndex] == .time {
            return "\(timeDiaries[section].year)年"
        }
        return ""
    }
    
}

extension ExportDiaryViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "f1f6fa")
        _ = navbar.then {
            $0.initData(title: "导出日记") { [weak self] in
                self?.goBack()
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        segement = UISegmentedControl(items: [ExportType.cate.rawValue, ExportType.location.rawValue, ExportType.time.rawValue]).then {
            $0.selectedSegmentIndex = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(navbar.snp.bottom).offset(12)
                $0.height.equalTo(36)
            }
            $0.addTarget(self, action: #selector(selectSegement(sender:)), for: .valueChanged)
        }
        
        setupTableView()
        
        _ = exporButton.then {
            $0.setTitle("导出", for: .normal)
            $0.setTitleColor(UIColor(hexString: "ffffff"), for: .normal)
            $0.layer.cornerRadius = 6
            $0.addShadow()
            $0.backgroundColor = UIColor(hexString: "0cc4c4")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-12)
                $0.height.equalTo(48)
            }
            $0.addTarget(self, action: #selector(exportDiaries), for: .touchUpInside)
        }
    }
    
    func setupTableView() {
        _ = tableView.then {
            $0.backgroundColor = .clear
            $0.separatorColor = .clear
            $0.rowHeight = 64
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView?.height = 100
            let footerView = UIView().then {
                $0.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: 100)
            }
            $0.tableFooterView = footerView
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(segement.snp.bottom).offset(12)
            }
            $0.register(ExportDiaryCell.self, forCellReuseIdentifier: ExportDiaryCell.identifier)
        }
    }
}
