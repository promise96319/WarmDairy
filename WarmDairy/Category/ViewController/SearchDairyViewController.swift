//
//  SearchDairyViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/21.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import ViewAnimator

class SearchDairyViewController: UIViewController {
    lazy var dairies = [DairyModel]()
    
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initData(dairies: [DairyModel]) {
        self.dairies = dairies
        CLog("dairies的值为: \(dairies)")
        collectionView.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells,
                           animations: self.animations, completion: {
                
                })
        }, completion: nil)
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
        let date = dairies[indexPath.row].createdAt
        MottoAPI.getMotto(mottoId: Int(date.toFormat("yyyyMMdd"))!) { (motto) in
            guard let motto = motto else { return }
            let vc = TodayDairyViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.initData(mottoData: motto)
            self.present(vc, animated: true, completion: nil)
        }
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
