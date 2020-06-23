//
//  CategoryEditViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import ViewAnimator
import SwiftyUserDefaults

class CategoryEditViewController: UIViewController {
    weak var delegate: CategoryViewController?
    
    let animations = [AnimationType.from(direction: .bottom, offset: 60.0)]
    lazy var categories = [CustomCategoryModel]()
    var currentSelectedCategoryIndex = -1
    
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton()
    lazy var addButton = UIButton()
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .categoryDidChanged, object: nil)
        (navigationController?.tabBarController as? TabBarViewController)?.hideTabbar()
        navigationController?.navigationBar.isHidden = true

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells,
                           animations: self.animations, duration: 1)
        }, completion: nil)
    }
    
    func initData(categories: [CustomCategoryModel]) {
        self.categories = categories
    }
    
    @objc func loadData() {
        CategoryAPI.getCategoriesWithDairies { (categories) in
            self.categories = categories
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        CLog("category edit 注销")
        NotificationCenter.default.removeObserver(self, name: .categoryDidChanged, object: nil)
    }
}

extension CategoryEditViewController {
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
        (navigationController?.tabBarController as? TabBarViewController)?.showTabbar()
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func addCate(isEdit: Bool = false) {
        AnalysisTool.shared.logEvent(event: "编辑归档_分类名称编辑")
        if !Defaults[.isVIP] && categories.count > VIPModel.categoryCount {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        let title = isEdit ? "编辑分类名称" : "添加分类"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
               
               alert.addTextField{(usernameText) ->Void in
                   usernameText.placeholder = "分类名称"
                if isEdit {
                    if self.currentSelectedCategoryIndex >= 0 {
                        usernameText.text = self.categories[self.currentSelectedCategoryIndex].name
                    }
                }
               }
               
               let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
               let confirm = UIAlertAction(title: "确定", style: .default, handler: {
                   ACTION in
                   let text = alert.textFields?.first?.text
                    if let text = text {
                        if text != "" {
                            if isEdit {
                                let cate = self.categories[self.currentSelectedCategoryIndex]
                                CategoryAPI.updateCategory(id: cate.id, name: text)  { _ in }
                            } else {
                                CategoryAPI.addCategory(name: text) { _ in }
                            }
                        }
                    }
               })
               
               alert.addAction(cancel)
               alert.addAction(confirm)
               self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cellLongPress(sender: UILongPressGestureRecognizer) {
        AnalysisTool.shared.logEvent(event: "编辑归档_长按弹出菜单")
        guard let tag = sender.view?.tag else { return }
        showCategoryEditOptions(tag: tag)
    }
    
    @objc func cellMoreClick(sender: UIButton) {
        let tag = sender.tag
        showCategoryEditOptions(tag: tag)
    }
    
    @objc func showCategoryEditOptions(tag: Int) {
        currentSelectedCategoryIndex = tag
        let alert = UIAlertController(title: "编辑分类", message: categories[tag].name, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "编辑", style: .default, handler: {
            ACTION in
            AnalysisTool.shared.logEvent(event: "编辑归档_长按_编辑")
            self.addCate(isEdit: true)
        })
        
        let delete = UIAlertAction(title: "删除", style: .destructive) { (ACTION) in
            AnalysisTool.shared.logEvent(event: "编辑归档_长按删除")
            let deleteAlert = UIAlertController(title: "删除分类", message: self.categories[tag].name, preferredStyle: .alert)
            
            let deleteCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteConfirm = UIAlertAction(title: "删除", style: .destructive, handler: {
                ACTION in
                AnalysisTool.shared.logEvent(event: "编辑归档_长按删除确认")
               CategoryAPI.removeCategory(id: self.categories[tag].id) { (isDeleted) in
               }
            })
            deleteAlert.addAction(deleteCancel)
            deleteAlert.addAction(deleteConfirm)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.addAction(delete)
        if DeviceInfo.isiPad {
            let popover = alert.popoverPresentationController
            if let popover = popover {
                popover.barButtonItem = self.navigationItem.rightBarButtonItem
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0, y: DeviceInfo.screenHeight, width: DeviceInfo.screenWidth, height: 360)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryEditViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySectionCell.identifier, for: indexPath) as! CategorySectionCell
        cell.initFavoriteData(data: categories[indexPath.row])
        cell.tag = indexPath.row
        cell.moreButton.tag = indexPath.row
        let longPressGuesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress))
        cell.addGestureRecognizer(longPressGuesture)
        cell.moreButton.addTarget(self, action: #selector(cellMoreClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AnalysisTool.shared.logEvent(event: "编辑归档_打开阅读器")
        if categories[indexPath.row].dairies.count == 0 {
            MessageTool.shared.showMessage(theme: .warning, title: "暂无日记", body: "请添加日记到该分类中再尝试查看")
            return
        }
        delegate?.setupReader(dairies: categories[indexPath.row].dairies)
    }
}

extension CategoryEditViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = titleLabel.then {
            $0.text = "我的收藏"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(12)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(14)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        _ = addButton.then {
            $0.setTitle("新增", for: .normal)
            $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.right.equalToSuperview().offset(-24)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(addCate), for: .touchUpInside)
        }
        
        let width = (DeviceInfo.screenWidth - 3 * 24) / 2
        let height = width * 3 / 2
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: width, height: height)
            $0.minimumLineSpacing = 24
            $0.minimumInteritemSpacing = 24
            $0.scrollDirection = .vertical
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0)
            $0.register(CategorySectionCell.self, forCellWithReuseIdentifier: CategorySectionCell.identifier)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(titleLabel.snp.bottom).offset(24)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
