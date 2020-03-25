//
//  CategorySection.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class CategorySection: UIView {
    
    weak var delegate: CategoryViewController?
    
    /// 是否是第一行，属于用于自定义的
    var isFavorite = false
    
    lazy var monthData = [CategoryMonthModel]()
    lazy var favoriteData = [CustomCategoryModel]()
    var currentSelectedCategoryIndex = -1
    
    lazy var titleLabel = UILabel()
    lazy var titleButton = UIButton()
    lazy var totalCountLabel = UILabel()
    lazy var collectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(year: Int, monthData: [CategoryMonthModel]) {
        self.isFavorite = false
        self.monthData = monthData.sorted(by: { $0.month < $1.month })
        
        titleLabel.text = "\(year)年"
        var totalCount = 0
        self.monthData.forEach {
            totalCount += $0.dairies.count
        }
        totalCountLabel.text = "\(totalCount)个故事"
        titleButton.isHidden = true
        
        collectionView.reloadData()
    }
    
    func initFavoriteData(data: [CustomCategoryModel]) {
        self.isFavorite = true
        self.favoriteData = data
        titleLabel.text = "我的收藏"
        totalCountLabel.isHidden = true
        collectionView.reloadData()
    }
}

// MARK: - 事件处理
extension CategorySection {
    @objc func showCategoryDetail() {
        let vc = CategoryEditViewController()
        vc.delegate = delegate
        vc.initData(categories: favoriteData)
        delegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 只有在用户自己的分类才出现
    @objc func addCate(isEdit: Bool = false) {
        let title = isEdit ? "编辑分类名称" : "添加分类"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
               
               alert.addTextField{(usernameText) ->Void in
                   usernameText.placeholder = "分类名称"
                if isEdit {
                    if self.currentSelectedCategoryIndex >= 0 {
                        usernameText.text = self.favoriteData[self.currentSelectedCategoryIndex].name
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
                                let cate = self.favoriteData[self.currentSelectedCategoryIndex]
                                CategoryAPI.updateCategory(id: cate.id, name: text)  { _ in }
                            } else {
                                CategoryAPI.addCategory(name: text) { _ in }
                            }
                        }
                    }
               })
               
               alert.addAction(cancel)
               alert.addAction(confirm)
        self.delegate?.present(alert, animated: true, completion: nil)
    }
    
    @objc func cellLongPress(sender: UILongPressGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        currentSelectedCategoryIndex = tag
        let alert = UIAlertController(title: "编辑分类", message: favoriteData[tag].name, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "添加", style: .default, handler: { ACTION in
            self.addCate()
        })
        let confirm = UIAlertAction(title: "编辑", style: .default, handler: {
            ACTION in
            self.addCate(isEdit: true)
        })
        
        let delete = UIAlertAction(title: "删除", style: .destructive) { (ACTION) in
            
            let deleteAlert = UIAlertController(title: "删除分类", message: self.favoriteData[tag].name, preferredStyle: .alert)
            
            let deleteCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteConfirm = UIAlertAction(title: "删除", style: .destructive, handler: {
                ACTION in
               CategoryAPI.removeCategory(id: self.favoriteData[tag].id) { (isDeleted) in
               }
            })
            deleteAlert.addAction(deleteCancel)
            deleteAlert.addAction(deleteConfirm)
            self.delegate?.present(deleteAlert, animated: true, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.addAction(add)
        alert.addAction(delete)
        if DeviceInfo.isiPad {
            let popover = alert.popoverPresentationController
            if let popover = popover {
                popover.sourceView = self.delegate?.view
                popover.sourceRect = CGRect(x: 0, y: DeviceInfo.screenHeight, width: DeviceInfo.screenWidth, height: 480)
            }
        }
        self.delegate?.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension CategorySection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavorite {
            return favoriteData.count
        } else {
            return monthData.count
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CategorySection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySectionCell.identifier, for: indexPath) as! CategorySectionCell
        if isFavorite {
            cell.initFavoriteData(data: favoriteData[indexPath.row])
            cell.tag = indexPath.row
            let longPressGuesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress))
            cell.addGestureRecognizer(longPressGuesture)
        } else {
            cell.initData(monthData: monthData[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFavorite {
            let dairies = favoriteData[indexPath.row].dairies
            if dairies.count == 0 {
                MessageTool.shared.showMessage(theme: .warning, title: "暂无日记", body: "请添加日记到该分类中再尝试查看")
            } else {
                delegate?.setupReader(dairies: dairies)
            }
        } else {
             delegate?.setupReader(dairies: monthData[indexPath.row].dairies)
        }
    }
}

extension CategorySection {
    func setupUI() {
        setupHeader()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: CategorySectionFrameModel.cellWidth, height: CategorySectionFrameModel.cellHeight)
            $0.minimumLineSpacing = CategorySectionFrameModel.spacing
            $0.minimumInteritemSpacing = CategorySectionFrameModel.spacing
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(CategorySectionFrameModel.cellHeight + CategorySectionFrameModel.cellVerticalSpacing * 2)
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview().offset(CategorySectionFrameModel.sectionHeader)
            }
            $0.register(CategorySectionCell.self, forCellWithReuseIdentifier: CategorySectionCell.identifier)
        }
        
    }
    
    func setupHeader() {
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview()
            }
        }
        
        _ = titleButton.then {
            $0.setTitle("更多...", for: .normal)
            $0.setTitleColor(UIColor(hexString: "606266"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.centerY.equalTo(titleLabel)
            }
            $0.addTarget(self, action: #selector(showCategoryDetail), for: .touchUpInside)
        }
        
        _ = totalCountLabel.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.centerY.equalTo(titleLabel)
            }
        }
    }
}
