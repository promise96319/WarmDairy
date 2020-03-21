//
//  SearchDairyViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class SearchDairyViewController: UIViewController {
    lazy var dairies = [DairyModel]()
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func initData(dairies: [DairyModel]) {
        self.dairies = dairies
        CLog("dairies的值为: \(dairies)")
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchDairyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dairies.count
    }
}

// MARK: - UICollectionViewDelegate
extension SearchDairyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        cell.initData(dairy: dairies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 点击事件
//        let vc = TodayDairyViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.initData(mottoData: mottoData[index])
//        present(vc, animated: true, completion: nil)
    }
}

extension SearchDairyViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        let width = DeviceInfo.screenWidth
        let height: CGFloat = 72
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: width, height: height)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .vertical
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 220, right: 0)
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0)
            $0.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
