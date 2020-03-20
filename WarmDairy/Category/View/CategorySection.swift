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
    
    lazy var monthData = [CategoryMonthModel]()
    
    lazy var titleLabel = UILabel()
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
        self.monthData = monthData.sorted(by: { $0.month < $1.month })
        
        titleLabel.text = "\(year)年"
        var totalCount = 0
        self.monthData.forEach {
            totalCount += $0.dairies.count
        }
        totalCountLabel.text = "\(totalCount)个故事"
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CategorySection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthData.count
    }
}

// MARK: - UICollectionViewDelegate
extension CategorySection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySectionCell.identifier, for: indexPath) as! CategorySectionCell
        cell.initData(monthData: monthData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.setupReader(dairies: monthData[indexPath.row].dairies)
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
