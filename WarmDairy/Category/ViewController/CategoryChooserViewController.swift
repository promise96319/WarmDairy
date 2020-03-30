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
    
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton()
    lazy var addButton = UIButton()
    lazy var saveButton = UIButton()
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .categoryDidChanged, object: nil)
        setupUI()
        loadData()
    }
    
    @objc func loadData() {
        CategoryAPI.getCategories { (categories) in
            self.categories = categories
            self.collectionView.reloadData()
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
    @objc func saveCate() {
        AnalysisTool.shared.logEvent(event: "编辑器_保存分类")
        let ids = catesID.map { "\($0)" }
        delegate?.moveToCate(cateIds: ids.joined(separator: ","))
        goBack()
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
    
}

// MARK: - UICollectionViewDataSource
extension CategoryChooserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryChooserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChooserCell.identifier, for: indexPath) as! CategoryChooserCell
        cell.initData(cate: categories[indexPath.row].name, isSelected: catesID.contains(categories[indexPath.row].id))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = categories[indexPath.row].id
        if catesID.contains(id) {
            catesID = catesID.filter { $0 != id }
        } else {
            catesID.append(id)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath)
            _ = addButton.then {
                $0.setTitle("新增分类", for: .normal)
                $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                footerView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.height.equalTo(44)
                    $0.width.equalToSuperview()
                }
                $0.addTarget(self, action: #selector(addCate), for: .touchUpInside)
            }
            return footerView
        }
        
        fatalError()
    }
    
}

// MARK: - UI 界面
extension CategoryChooserViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = titleLabel.then {
            $0.text = "日记分类"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(10)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        _ = saveButton.then {
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.right.equalToSuperview().offset(-24)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(saveCate), for: .touchUpInside)
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: DeviceInfo.screenWidth - 48, height: 44)
            $0.minimumLineSpacing = 12
            $0.minimumInteritemSpacing = 12
            $0.scrollDirection = .vertical
            $0.footerReferenceSize = CGSize(width: DeviceInfo.screenWidth - 48, height: 44)
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0)
            $0.register(CategoryChooserCell.self, forCellWithReuseIdentifier: CategoryChooserCell.identifier)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(titleLabel.snp.bottom).offset(24)
                $0.bottom.equalToSuperview()
            }
            $0.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        }
    }
}
