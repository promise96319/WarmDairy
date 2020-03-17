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

class HomeViewController: UIViewController {
    
    var mottoData = [MottoModel(), MottoModel(),MottoModel(),]
    
    let heroID = "Home_Carousel_ID"
    
    lazy var welcomeLabel = UILabel()
    lazy var welcomeMotto = UILabel()
    lazy var bgImage = UIImageView()
    lazy var editButton = UIButton()
    
    lazy var carouselPager = FSPagerView()
    
    override func viewDidLoad() {
        setupUI()
        showEditor()
    }
}

extension HomeViewController {
    @objc func showEditor() {
        let vc = EditorViewController()
        vc.modalPresentationStyle = .fullScreen
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
        cell.initData(mottoData: mottoData[index], index: index)
//        cell.bgImage.hero.id = "\(heroID)bgImage\(index)"
//        cell.imageMaskView.hero.id = "\(heroID)mask\(index)"
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let vc = TodayDairyViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.bgImage.image = UIImage(named: "image_home_cr\(index + 1)")
//        vc.bgImage.hero.id = "\(heroID)bgImage\(index)"
//        vc.bgMask.hero.id = "\(heroID)mask\(index)"
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
            $0.setTitle("+", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius = 32
            $0.clipsToBounds = true
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
//            $0.transformer = FSPagerViewTransformer(type: .ferrisWheel)
//            $0.transformer = FSPagerViewTransformer(type: .coverFlow)
            
            $0.transformer = FSPagerViewTransformer(type: .linear)
            $0.isInfinite = true
            
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
