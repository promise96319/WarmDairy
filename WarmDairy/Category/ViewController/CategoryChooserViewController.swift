//
//  CategoryChooserViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

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
        NotificationCenter.default.removeObserver(self, name: .categoryDidChanged, object: nil)
    }
}

extension CategoryChooserViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    @objc func saveCate() {
        let ids = catesID.map { "\($0)" }
        delegate?.moveToCate(cateIds: ids.joined(separator: ","))
        goBack()
    }
    
    @objc func addCate() {
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
                    CategoryAPI.addCategory(name: text) { (isAdded) in
                        if isAdded {
                            NotificationCenter.default.post(name: .categoryDidChanged, object: nil)
                        }
                    }
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
        
        //        _ = backButton.then {
        //            $0.setImage(R.image.icon_editor_back(), for: .normal)
        //            view.addSubview($0)
        //            $0.snp.makeConstraints {
        //                $0.centerY.equalTo(titleLabel)
        //                $0.left.equalToSuperview().offset(14)
        //                $0.width.height.equalTo(44)
        //            }
        //            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        //        }
        
        _ = addButton.then {
            $0.setTitle("新增", for: .normal)
            $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(24)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(addCate), for: .touchUpInside)
        }
        
        _ = saveButton.then {
            $0.setTitle("保存", for: .normal)
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
            $0.itemSize = CGSize(width: DeviceInfo.screenWidth - 48, height: 30)
            $0.minimumLineSpacing = 12
            $0.minimumInteritemSpacing = 12
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
            $0.register(CategoryChooserCell.self, forCellWithReuseIdentifier: CategoryChooserCell.identifier)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalTo(titleLabel.snp.bottom).offset(24)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - 分类cell
class CategoryChooserCell: UICollectionViewCell {
    static let identifier = "CategoryChooserCell_ID"
    lazy var cateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(cate: String, isSelected: Bool) {
        cateLabel.text = cate
        if isSelected {
            cateLabel.textColor = UIColor(hexString: "409eff")
        } else {
            cateLabel.textColor = UIColor(hexString: "303133")
        }
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse()
    }
}

extension CategoryChooserCell {
    func setupUI() {
        _ = cateLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
    }
}
