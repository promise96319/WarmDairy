//
//  MeViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import ViewAnimator

class MeViewController: UIViewController {
    lazy var userInfo = UserInfo()
    
    var allMoods = Moods.all
    let totalHeight: CGFloat = 132
    var moodTotalCount = 0
    var moodMaxCount = 0
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var bgImage = UIImageView()
    lazy var settingButton = UIButton()
    
    lazy var userContainer = UIView()
    lazy var avatarImageView = UIImageView()
    lazy var usernameLabel = UILabel()
    lazy var userMottolLabel = UILabel()
    
    lazy var allDairyLabel = UILabel()
    lazy var recordTimeLabel = UILabel()
    lazy var continousCreateLabel = UILabel()
    
    lazy var premiumView = UIView()
    
    lazy var moodView = UIView()
    lazy var moodTitle = UILabel()
    lazy var moodCountLabel = UILabel()
    var moodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userContainer.alpha = 0
        premiumView.alpha = 0
        moodView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: .userInfoDidChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .dairyDidAdded, object: nil)
        setupUI()
        loadUserInfo()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnimations()
    }
    
    func setupAnimations() {
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 120.0)
        view.animate(animations: [fromAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1)

        let cellAnimation = AnimationType.from(direction: .bottom, offset: 60.0)
        UIView.animate(views: [userContainer, moodView], animations: [cellAnimation], duration: 0.8)

        let moodCellAnimation = AnimationType.from(direction: .right, offset: 60.0)
        moodCollectionView?.performBatchUpdates({ [weak self] in
            guard let weakSelf = self, let collectionView = weakSelf.moodCollectionView else { return }
            UIView.animate(views: collectionView.orderedVisibleCells,
                           animations: [moodCellAnimation], duration: 1)
        }, completion: nil)
    }
    
    @objc func loadUserInfo() {
        UserInfoAPI.getUser { [weak self] (userInfo) in
            guard let weakSelf = self else { return }
            weakSelf.userInfo = userInfo
            weakSelf.usernameLabel.text = userInfo.name
            weakSelf.userMottolLabel.text = userInfo.motto
            
            weakSelf.recordTimeLabel.text = weakSelf.formatRecordTime(minutes: userInfo.recordTime)
            weakSelf.continousCreateLabel.text = "\(userInfo.continuousCreation)天"
            if let data = userInfo.avatar?.storedData() {
                weakSelf.avatarImageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func loadData() {
        self.moodTotalCount = 0
        self.moodMaxCount = 0
        DairyAPI.getDairy { [weak self] (dairies) in
            guard let weakSelf = self else { return }
            weakSelf.allDairyLabel.text = "\(dairies.count)篇"
            for mood in weakSelf.allMoods {
                mood.dairyCount = 0
            }
            for dairy in dairies {
                for (index, mood) in weakSelf.allMoods.enumerated() {
                    if mood.image == dairy.mood {
                        weakSelf.allMoods[index].dairyCount += 1
                    }
                }
            }
            
            weakSelf.allMoods.forEach { mood in
                weakSelf.moodTotalCount += mood.dairyCount
                if mood.dairyCount > weakSelf.moodMaxCount {
                    weakSelf.moodMaxCount = mood.dairyCount
                }
            }
            weakSelf.moodCountLabel.text = "\(weakSelf.moodTotalCount)个心情"
            weakSelf.moodCollectionView.reloadData()
        }
    }
    
    func formatRecordTime(minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)分钟"
        }
        
        let hour = Int(minutes / 60)
        let minute = minutes % 60
        return "\(hour)小时\(minute)分"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userInfoDidChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .dairyDidAdded, object: nil)
        CLog("me 注销")
    }
}

// MARK: - 事件处理
extension MeViewController {
    @objc func showSetting() {
        AnalysisTool.shared.logEvent(event: "我-设置按钮")
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showSubscription() {
        AnalysisTool.shared.logEvent(event: "我-订阅按钮")
        let vc = SubscriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMoods.count
    }
}

// MARK: - UICollectionViewDelegate
extension MeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeMoodCell.identifier, for: indexPath) as! MeMoodCell
        var moodHeight: CGFloat!
        if moodMaxCount == 0 {
            moodHeight = 0
        } else {
            moodHeight = totalHeight * CGFloat(allMoods[indexPath.row].dairyCount) / CGFloat(moodMaxCount)
        }
        cell.initData(moodHeight: moodHeight, mood: allMoods[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UI 界面
extension MeViewController {
    func setupUI() {
        setBackgroud()
        setupUser()
        setupRecord()
        setupPremiumView()
        setupMoods()
        moodView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom).offset(-64)
        }
    }
    
    func setupMoods() {
        _ = moodView.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                if Defaults[.isVIP] {
                    $0.top.equalTo(userContainer.snp.bottom).offset(16)
                } else {
                    $0.top.equalTo(userContainer.snp.bottom).offset(16 + 80)
                }
                $0.height.equalTo(MeMoodFrameModel.height + 54)
            }
        }
        
        _ = moodTitle.then {
            $0.text = "心情记录"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            moodView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(12)
            }
        }
        
        _ = moodCountLabel.then {
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            moodView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-12)
                $0.centerY.equalTo(moodTitle)
            }
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: MeMoodFrameModel.cellWidth, height: MeMoodFrameModel.cellHeight)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        moodCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            moodView.addSubview($0)
            $0.register(MeMoodCell.self, forCellWithReuseIdentifier: MeMoodCell.identifier)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview().offset(36)
                $0.height.equalTo(MeMoodFrameModel.height)
            }
        }
    }
    
    func setupPremiumView() {
        let premiumView = UIView().then {
            $0.isHidden = Defaults[.isVIP]
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.top.equalTo(userContainer.snp.bottom).offset(16)
                $0.height.equalTo(64)
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSubscription))
            $0.addGestureRecognizer(tapGesture)
        }
        _ = UIImageView().then {
            $0.isUserInteractionEnabled = true
            $0.image = R.image.image_me_bg()
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.5)
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let image = UIImageView().then {
            $0.image = R.image.icon_me_premium()
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(28)
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview().offset(-50)
            }
        }
        _ = UILabel().then {
            $0.text = "解锁高级版"
            $0.textColor = UIColor(hexString: "F4C204")
            $0.font = UIFont.systemFont(ofSize: 20)
            premiumView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(image.snp.right).offset(8)
            }
        }
    }
    
    func setupRecord() {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.top.equalTo(bgImage.snp.bottom).offset(20)
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        func generateItemStack(label: UILabel, text: String) -> UIStackView {
            let itemStack = UIStackView().then {
                $0.axis = .vertical
                $0.distribution = .fillProportionally
                $0.spacing = 4
            }
            label.textColor = UIColor(hexString: "303133")
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            itemStack.addArrangedSubview(label)
            _ = UILabel().then {
                $0.text = text
                $0.textColor = UIColor(hexString: "454B51")
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textAlignment = .center
                itemStack.addArrangedSubview($0)
            }
            return itemStack
        }
        
        _ = allDairyLabel.then {
            $0.text = "0篇"
        }
        
        _ = recordTimeLabel.then {
            $0.text = "0分"
        }
        
        _ = continousCreateLabel.then {
            $0.text = "0天"
        }
        
        stackView.addArrangedSubview(generateItemStack(label: allDairyLabel, text: "所有日记"))
        stackView.addArrangedSubview(generateItemStack(label: recordTimeLabel, text: "记录时长"))
        stackView.addArrangedSubview(generateItemStack(label: continousCreateLabel, text: "活跃天数"))
        
    }
    
    func setupUser() {
        _ = userContainer.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.height.equalTo(180)
                $0.top.equalTo(bgImage.snp.bottom).offset(-90)
            }
        }
        
        let container = UIView().then {
            $0.layer.cornerRadius = 6
            userContainer.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.height.equalTo(100)
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSetting))
            $0.addGestureRecognizer(tapGesture)
        }
        
        _ = avatarImageView.then {
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.top.equalToSuperview().offset(-16)
                $0.width.height.equalTo(84)
            }
        }
        
        _ = usernameLabel.then {
            $0.text = ""
            $0.textColor = UIColor(hexString: "161A1A")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(6)
                $0.left.equalTo(avatarImageView.snp.right).offset(12)
            }
        }
        
        _ = userMottolLabel.then {
            $0.text = ""
            $0.textColor = UIColor(hexString: "606266")
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
            container.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(usernameLabel)
                $0.top.equalTo(usernameLabel.snp.bottom).offset(6)
                $0.right.equalToSuperview().offset(-12)
            }
        }
    }
    
    func setBackgroud() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
        
        _ = bgImage.then {
            $0.image = R.image.image_me_bg()
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(-DeviceInfo.topSafeAreaHeight)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(DeviceInfo.topSafeAreaHeight + 200)
            }
        }
        
        let bgView = UIView().then {
            $0.layer.cornerRadius = 22
            $0.addShadow()
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(88)
                $0.height.equalTo(44)
                $0.top.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(22)
            }
        }
        
        let maskView = UIView().then {
            $0.layer.cornerRadius = 22
            $0.clipsToBounds = true
            bgView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = UIVisualEffectView().then {
            $0.effect = UIBlurEffect(style: .regular)
            maskView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = settingButton.then {
            $0.setImage(R.image.icon_me_setting(), for: .normal)
            bgView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(44)
                $0.right.equalToSuperview().offset(-16 - 22)
            }
            $0.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
        }
    }
    
    func addBg(view: UIView) {
        view.backgroundColor = UIColor(hexString: "FEFFFF", alpha: 0.8)
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
