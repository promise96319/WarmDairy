//
//  CategoryChooserViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol CategoryChooserDelegate {
    func moveToCate(cateIds: String) -> Void
}

class CategoryChooserViewController: UIViewController {
    var delegate: CategoryChooserDelegate?
    
    lazy var categories = [CategoryModel]()
    lazy var catesID = [Int]()
    
    lazy var navbar = CustomNavigationBar()
    lazy var categoryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .categoryDidChanged, object: nil)
        setupUI()
        loadData()
    }
    
    @objc func loadData() {
        CategoryAPI.getCategories { (categories) in
            self.categories = categories
            self.categoryTableView.reloadData()
        }
    }
    
    func initData(cateIds: String) {
        self.catesID = cateIds.split(separator: ",").map { Int(String($0))! }
    }
    
    deinit {
        CLog("chooserview注销")
        NotificationCenter.default.removeObserver(self, name: .categoryDidChanged, object: nil)
    }
}

extension CategoryChooserViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addCate() {
        AnalysisTool.shared.logEvent(event: "编辑器_添加分类")
        if !Defaults[.isVIP] && categories.count > VIPModel.categoryCount {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "添加分类", message: "", preferredStyle: .alert)
        
        alert.addTextField{(usernameText) ->Void in
            usernameText.placeholder = "分类名称"
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    CategoryAPI.addCategory(name: text) { _ in }
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editCate(cate: CategoryModel) {
        AnalysisTool.shared.logEvent(event: "编辑器_编辑分类")
        
        let alert = UIAlertController(title: "编辑分类", message: "", preferredStyle: .alert)
        
        alert.addTextField{(usernameText) ->Void in
            usernameText.text = cate.name
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    CategoryAPI.updateCategory(id: cate.id, name: text) { (isUpdated) in
                        if isUpdated {
                            
                        }
                    }
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteCate(index: Int) {
        let deleteAlert = UIAlertController(title: "删除分类", message: categories[index].name, preferredStyle: .alert)
        
        let deleteCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteConfirm = UIAlertAction(title: "删除", style: .destructive, handler: {
            [weak self] ACTION in
            guard let self = self else { return }
            CategoryAPI.removeCategory(id: self.categories[index].id) { (isDeleted) in
            }
        })
        deleteAlert.addAction(deleteCancel)
        deleteAlert.addAction(deleteConfirm)
        present(deleteAlert, animated: true, completion: nil)
    }
}

extension CategoryChooserViewController: CategoryChooserCellDelegate {
    func moreButtonClicked(index: Int) {
        let cate = categories[index]
        let alert = UIAlertController(title: "编辑分类", message: cate.name, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "编辑", style: .default, handler: {
            ACTION in
            AnalysisTool.shared.logEvent(event: "归档_长按编辑分类")
            self.editCate(cate: cate)
        })
        
        let delete = UIAlertAction(title: "删除", style: .destructive) { (ACTION) in
            self.deleteCate(index: index)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.addAction(delete)
        if DeviceInfo.isiPad {
            let popover = alert.popoverPresentationController
            if let popover = popover {
                popover.sourceView = view
                popover.sourceRect = CGRect(x: 0, y: DeviceInfo.screenHeight, width: DeviceInfo.screenWidth, height: 480)
            }
        }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - delegate
extension CategoryChooserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (rowAction, indexPath) in
            self?.deleteCate(index: indexPath.row)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { [weak self] (rowAction, indexPath) in
            guard let self = self else { return }
            self.editCate(cate: self.categories[indexPath.row])
        }
        
        editAction.backgroundColor = UIColor(hexString: "0CC4C4")
        
        return [deleteAction, editAction]
    }
}
extension CategoryChooserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryChooserCell.identifier, for: indexPath) as! CategoryChooserCell
        cell.selectionStyle = .none
        cell.initData(cate: categories[indexPath.row].name, isSelected: catesID.contains(categories[indexPath.row].id), index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = categories[indexPath.row].id
        if catesID.contains(id) {
            catesID = catesID.filter { $0 != id }
        } else {
            catesID.append(id)
        }
        let ids = catesID.map { "\($0)" }
        delegate?.moveToCate(cateIds: ids.joined(separator: ","))
        categoryTableView.reloadData()
    }
}


// MARK: - UI 界面
extension CategoryChooserViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = navbar.then {
            $0.initData(title: "日记分类", isPresent: true, rightText: "添加") { [weak self] in
                self?.goBack()
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        navbar.rightButton.addTarget(self, action: #selector(addCate), for: .touchUpInside)
        
        _ = categoryTableView.then {
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
            $0.register(CategoryChooserCell.self, forCellReuseIdentifier: CategoryChooserCell.identifier)
        }
    }
}
