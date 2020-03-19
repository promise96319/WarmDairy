//
//  HomeViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/6.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SnapKit
import Then
import FSPagerView
import Hero
import SwiftyUserDefaults

class HomeViewController: UIViewController {
    
    var mottoData = [MottoModel]()
    
    let heroID = "Home_Carousel_ID"
    
    lazy var welcomeLabel = UILabel()
    lazy var welcomeMotto = UILabel()
    lazy var bgImage = UIImageView()
    lazy var editButton = UIButton()
    
    lazy var carouselPager = FSPagerView()
    
    override func viewDidLoad() {
        setupUI()
        loadData()
//        showEditor()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .dairyDidAdded, object: nil)
    }
    
    @objc func loadData() {
        MottoAPI.getMottos { (data) in
            // 如果没有数据，或者有数据时最后一天不是今天，创建一个新的空数据
            if data.count == 0 || (data.count > 0 && !data[data.count - 1].date.compare(.isToday)) {
                // 如果今天没有手动创建，则手动创建，有则复用今天的
                if (Defaults[.todayMottoImage] == "") {
                    let motto = MottoAPI.generateRandomMotto()
                    Defaults[.todayMottoImage] = motto.0
                    Defaults[.todayMotto] = motto.1
                    Defaults[.todayMottoAuthor] = motto.2
                }
                
                let todayMotto = MottoModel()
                todayMotto.imageURL = Defaults[.todayMottoImage]
                todayMotto.motto = Defaults[.todayMotto]
                todayMotto.author = Defaults[.todayMottoAuthor]
                // 记一个标识符，看是否为今天创建
                todayMotto.isDeleted = true
                self.mottoData = data
                self.mottoData.append(todayMotto)
                print("测试 ===> 今天存在格言")
            } else {
                print("测试 ===> 不存在格言")
                self.mottoData = data
            }
            
            self.carouselPager.reloadData()
            self.carouselPager.layoutIfNeeded()
            if (self.mottoData.count > 1) {
                DispatchQueue.main.async {
                    self.carouselPager.scrollToItem(at: self.mottoData.count - 1, animated: false)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dairyDidAdded, object: nil)
    }
}

// MARK: - 事件
extension HomeViewController {
    @objc func showEditor() {
        let vc = EditorViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.initBg(image: mottoData[mottoData.count - 1].imageURL)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return mottoData.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, at: index) as! CarouselCell
        cell.initData(mottoData: mottoData[index])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        // 如果isDeleted为 true, 说明是手动创建的今天motto，此时是没有数据的
        if mottoData[index].isDeleted {
            let vc = EditorViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.initBg(image: mottoData[index].imageURL)
            present(vc, animated: true, completion: nil)
            return
        }
        
        let vc = TodayDairyViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.initData(mottoData: mottoData[index])
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UI 界面
extension HomeViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        setupWelcome()
        setupCarousel()
        
        _ = editButton.then {
            $0.setImage(R.image.icon_home_add(), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius = 32
            $0.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 2, height: 4)
            $0.layer.shadowRadius = 10
            $0.backgroundColor = UIColor(hexString: "0cc4c4")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.bottom.equalToSuperview().offset(-CustomTabBarView.tabbarHeight-24)
                $0.width.height.equalTo(64)
            }
            $0.addTarget(self, action: #selector(showEditor), for: .touchUpInside)
        }
    }
    
    func setupCarousel() {
        _ = carouselPager.then {
            $0.transformer = FSPagerViewTransformer(type: .linear)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-CustomTabBarView.tabbarHeight - 64)
                $0.top.equalTo(welcomeMotto.snp.bottom).offset(24)
            }
            $0.itemSize = CGSize(width: CarouselFrameModel.cellWidth, height: CarouselFrameModel.cellHeight)
            $0.interitemSpacing = CarouselFrameModel.horizontalSpacing
            $0.delegate = self
            $0.dataSource = self
            $0.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        }
    }
    
    func setupWelcome() {
        _ = welcomeLabel.then {
            $0.set(text: "下午好，Silence~", size: 28, weight: .medium)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(48)
            }
        }
        
        _ = welcomeMotto.then {
            $0.set(text: "Good good study, day day up!", color: "606266")
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(welcomeLabel)
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(10)
                $0.width.equalTo(DeviceInfo.screenWidth - 148)
            }
        }
        
        _ = bgImage.then {
            $0.image = R.image.image_home_bg_sun()
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
                $0.right.equalToSuperview().offset(16)
            }
        }
    }
}
