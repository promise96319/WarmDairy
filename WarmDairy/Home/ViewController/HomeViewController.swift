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
import SwiftyUserDefaults
import ViewAnimator
import MBProgressHUD

class HomeViewController: UIViewController {
    
    var mottoData = [MottoModel]()
    lazy var userInfo = UserInfo()
    
    let heroID = "Home_Carousel_ID"
    
    lazy var welcomeLabel = UILabel()
    lazy var welcomeMotto = UILabel()
    lazy var bgImage = UIImageView()
    lazy var editButton = UIButton()
    lazy var carouselPager = FSPagerView()
    
    override func viewDidLoad() {
        loadInfo()
        if userInfo.isLaunchPasswordEnable {
            lockScreen()
        } else {
            if !Defaults[.isVIP] {
                let vc = SubscriptionViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            }
        }
        
        view.alpha = 0
        editButton.alpha = 0
        welcomeLabel.alpha = 0
        welcomeMotto.alpha = 0
        editButton.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .dairyDidAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadInfo), name: .userInfoDidChanged, object: nil)
        
        setupUI()
        
        loadData()
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.repeatCount = MAXFLOAT
        animation.duration = 16
        animation.fromValue = 0
        animation.toValue = Double.pi
        animation.isRemovedOnCompletion = false
        bgImage.layer.add(animation, forKey: "transform.rotation.z")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        welcomeLabel.text = "\(caculateTime())，\(userInfo.name)"
        setupAnimations()
    }
    
    func lockScreen() {
        let vc = AboutMeViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.navbar.alpha = 0
        present(vc, animated: false, completion: nil)
        
        PasswordManager.shared.passwordAuth(reason: "启动 Warm Diarry") { [weak self] (success) in
            if success {
                DispatchQueue.main.async {
                    vc.dismiss(animated: false, completion: nil)
                    if !Defaults[.isVIP] {
                        let vc = SubscriptionViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func loadInfo() {
        UserInfoAPI.getUser { [weak self] (userInfo) in
            guard let weakSelf = self else { return }
            weakSelf.userInfo = userInfo
            let time = self?.caculateTime() ?? "你好"
            weakSelf.welcomeLabel.text = "\(time)，\(userInfo.name)"
            weakSelf.welcomeMotto.text = userInfo.motto
        }
    }
    
    @objc func loadData() {
        MottoAPI.getMottos { [weak self] (data) in
            CLog("测试 ===> motto data的值为: \(data)")
            // 如果没有数据，或者有数据时最后一天不是今天，创建一个新的空数据
            if data.count == 0 || (data.count > 0 && !data[data.count - 1].date.compare(.isToday)) {
                // 如果今天没有手动创建，则手动创建，有则复用今天的
                if (Defaults[.todayMottoImage] == "") {
                    let motto = MottoAPI.generateRandomMotto(index: data.count)
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
                self?.mottoData = data
                self?.mottoData.append(todayMotto)
                CLog("测试 ===> 今天存在格言")
            } else {
                CLog("测试 ===> 不存在格言")
                self?.mottoData = data
            }
            
            self?.carouselPager.reloadData()
            self?.carouselPager.layoutIfNeeded()
            if ((self?.mottoData.count)! > 1) {
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.carouselPager.scrollToItem(at: weakSelf.mottoData.count - 1, animated: false)
                }
            }
        }
    }
    
    func caculateTime() -> String {
        let date = Date()
        if date.compare(.isMorning) {
            return "早上好"
        }
        if date.compare(.isAfternoon) {
            return "下午好"
        }
        if date.compare(.isEvening) {
            return "晚上好"
        }
        return "晚安"
    }
    
    deinit {
        CLog("home 注销")
        NotificationCenter.default.removeObserver(self, name: .dairyDidAdded, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userInfoDidChanged, object: nil)
    }
}

// MARK: - 事件
extension HomeViewController {
    @objc func showEditor() {
        AnalysisTool.shared.logEvent(event: "首页-添加按钮点击")
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
        AnalysisTool.shared.logEvent(event: "首页-轮播图cell点击")
        // 如果isDeleted为 true, 说明是手动创建的今天motto，此时是没有数据的
        if mottoData[index].isDeleted {
            let vc = EditorViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.initBg(image: mottoData[index].imageURL)
            present(vc, animated: true, completion: nil)
            return
        }
        
        let hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub.mode = .indeterminate
        hub.animationType = .fade
        hub.show(animated: true)
        
        /// 先获取数据再进入
        DairyAPI.getDairy(date: mottoData[index].date) { [weak self] (dairies) in
            hub.hide(animated: true)
            guard let self = self else { return }
            let vc = TodayDairyViewController()
            vc.initData(mottoData: self.mottoData[index], dairies: dairies)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
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
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 28, weight: .medium)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(48)
            }
        }
        
        _ = welcomeMotto.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.setLineSpacing(lineSpacing: 12, lineHeightMultiple: 1)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(welcomeLabel)
                $0.top.equalTo(welcomeLabel.snp.bottom).offset(10)
                $0.width.equalTo(DeviceInfo.screenWidth - 148)
            }
        }
        
        _ = bgImage.then {
            $0.image = R.image.image_bg_sun()
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(144)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
                $0.right.equalToSuperview().offset(16)
            }
        }
    }
}

// MARK: - 动画
extension HomeViewController {
    func setupAnimations() {
        
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 120.0)
        view.animate(animations: [fromAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1)
        
        let scaleAnimation = AnimationType.zoom(scale: 0)
        
        editButton.animate(animations: [scaleAnimation], reversed: false, initialAlpha: 1, finalAlpha: 1, delay: 0.4, duration: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, completion: nil)
        
        //        bgImage.animate(animations: [scaleAnimation], reversed: false, initialAlpha: 1, finalAlpha: 1, delay: 0.2, duration: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 2) {
        //        }
        
        
        
        let labelAnimation = AnimationType.from(direction: .bottom, offset: 20.0)
        welcomeLabel.animate(animations: [labelAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0.2, duration: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, completion: nil)
        welcomeMotto.animate(animations: [labelAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0.2, duration: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, completion: nil)
        
        
        for index in 0..<mottoData.count {
            if let cell = carouselPager.cellForItem(at: index) {
                let zoomAnimation = AnimationType.zoom(scale: 0.8)
                UIView.animate(views: [cell],
                               animations: [zoomAnimation],
                               duration: 1)
            }
        }
    }
}
