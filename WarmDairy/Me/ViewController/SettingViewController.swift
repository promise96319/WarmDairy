//
//  SettingViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import Photos
import SwiftyUserDefaults
import MBProgressHUD
import SafariServices

class SettingViewController: UIViewController {
    
    lazy var userInfo = UserInfo()
    
    lazy var hearerContainer = CustomNavigationBar()
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var userContainer = UIView()
    lazy var avatarCell = SettingCell()
    lazy var nameCell = SettingCell()
    lazy var discriptionCell = SettingCell()
    
    lazy var settingContainer = UIView()
    lazy var reminderCell = SettingCell()
    lazy var imageQualityCell = SettingCell()
    lazy var passwordCell = SettingCell()
    lazy var exportDiaryCell = SettingCell()
    
    lazy var purchaseContainer = UIView()
    lazy var subscriptionCell = SettingCell()
    lazy var restoreCell = SettingCell()
    lazy var restoreLifetimeCell = SettingCell()
    lazy var termsCell = SettingCell()
    lazy var policyCell = SettingCell()
    
    lazy var aboutContaier = UIView()
    lazy var helpCell = SettingCell()
    lazy var rateCell = SettingCell()
    lazy var shareCell = SettingCell()
    lazy var aboutCell = SettingCell()
    
    var hub: MBProgressHUD?
    
    var picker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .userInfoDidChanged, object: nil)
        (navigationController?.tabBarController as? TabBarViewController)?.hideTabbar()
        setupUI()
        loadData()
    }
    
    @objc func loadData() {
        UserInfoAPI.getUser { [weak self] (userInfo) in
            CLog("user的值为: \(userInfo)")
            self?.userInfo = userInfo
            
            self?.avatarCell.initData(leftText: "头像", avatar: userInfo.avatar) { [weak self] in
                self?.chooseAvatar()
            }
            self?.nameCell.initData(leftText: "昵称", rightText: userInfo.name) { [weak self] in
                self?.rename()
            }
            self?.discriptionCell.initData(leftText: "个性签名", rightText: userInfo.motto, isBorder: false) { [weak self] in
                self?.changeDiscription()
            }
            
            self?.passwordCell.rightSwitch.isOn = userInfo.isLaunchPasswordEnable
        }
    }
    
    deinit {
        CLog("setting 注销")
        NotificationCenter.default.removeObserver(self, name: .userInfoDidChanged, object: nil)
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }
        let imageData = ImageCompressTool.compress(image: pickedImage, to: 300)
        
        picker.dismiss(animated: true, completion: nil)
        
        let avatar = CreamAsset.create(object: self.userInfo, propName: UserInfo.avatarKey, data: imageData!)
        UserInfoAPI.saveUserInfo(userInfo: ["avatar": avatar as Any])
    }
}

// MARK: -  ************ 用户设置 ************
extension SettingViewController {
    func setReminder() {
        CLog("ssss的值为: \(Defaults[.isReminderOn])")
        if (Defaults[.isReminderOn]) {
            reminderCell.rightArrowIcon.isHidden = true
            reminderCell.rightLabel.text = "\(Defaults[.reminderHour])时\(Defaults[.reminderMinute])分"
            reminderCell.rightLabel.isHidden = false
        } else {
            reminderCell.rightLabel.isHidden = true
            reminderCell.rightArrowIcon.isHidden = false
        }
    }
    
    @objc func setLaunchScreenPassword(sender: UISwitch) {
        AnalysisTool.shared.logEvent(event: "设置-锁屏密码")
        let isOn = sender.isOn
        PasswordManager.shared.passwordAuth(reason: "Warm Diary 锁屏") { [weak self] (success) in
            if (success) {
                // 设置成功，保存到用户信息中
                UserInfoAPI.saveUserInfo(userInfo: ["isLaunchPasswordEnable": isOn as Any], isNotify: false)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.passwordCell.rightSwitch.isOn = !isOn
                }
            }
        }
    }
    
    func showChooseImageQuality() {
        AnalysisTool.shared.logEvent(event: "设置_图片质量")
        let alert = UIAlertController(title: "日记图片质量", message: "为了保证App运行更加流畅，请注意不要上传过多高质量的照片。", preferredStyle: .actionSheet)
        
        for (index, imageQualityModel) in ImageQuality.all.enumerated()  {
            let confirm = UIAlertAction(title: imageQualityModel.name, style: .default, handler: {
                [weak self] ACTION in
                AnalysisTool.shared.logEvent(event: "设置_图片质量_\(imageQualityModel.name)")
                Defaults[.imageQuality] = index
                self?.imageQualityCell.rightLabel.text = imageQualityModel.name
            })
            
            alert.addAction(confirm)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        if DeviceInfo.isiPad {
            let popover = alert.popoverPresentationController
            if let popover = popover {
                popover.barButtonItem = self.navigationItem.rightBarButtonItem
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0, y: DeviceInfo.screenHeight, width: DeviceInfo.screenWidth, height: 360)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -  ************ App相关信息 ************
extension SettingViewController {
    func showHelpDocment() {
        //        https://sites.google.com/view/warmdiary-helpdocument
        AnalysisTool.shared.logEvent(event: "设置-帮助文档按钮")
        if let url = URL(string: URLManager.help.rawValue) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showRate() {
        AnalysisTool.shared.logEvent(event: "设置-评分按钮")
        let appID = "1504446852"
        let str = "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review"
        UIApplication.shared.open(URL(string: str)!, options: [:], completionHandler: nil)
    }
    
    func share() {
        AnalysisTool.shared.logEvent(event: "设置-分享点击")
        let text = "我在Warm Diary里写了一本日记，你也来写一写吧~"
        let url = URL.init(string: URLManager.share.rawValue)!
        let image = R.image.launch_logo()
        let activityVC = UIActivityViewController(activityItems: [text, url, image as Any], applicationActivities: nil)
        
        if DeviceInfo.isiPad {
            let popOver = activityVC.popoverPresentationController
            popOver?.sourceView = view
            popOver?.sourceRect = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: 340)
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    func showAbout() {
        AnalysisTool.shared.logEvent(event: "设置-关于我们点击")
        let vc = AboutMeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: -  ************ 购买相关事件 ************
extension SettingViewController {
    func showSubscription() {
        AnalysisTool.shared.logEvent(event: "设置-订阅按钮")
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员，无需再次购买")
            return
        }
        
        let vc = SubscriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func restore() {
        AnalysisTool.shared.logEvent(event: "设置-恢复按钮")
        restoreAllPurchase()
    }
    
    func restoreLifetime() {
        AnalysisTool.shared.logEvent(event: "设置-恢复终身按钮")
        purchaseConsumable(id: IAPManager.ProductID.lifetime)
    }
    
    func showTerms() {
        AnalysisTool.shared.logEvent(event: "设置-使用协议按钮")
        if let url = URL(string: URLManager.terms.rawValue) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showPolicy() {
        AnalysisTool.shared.logEvent(event: "设置-隐私按钮")
        
        if let url = URL(string: URLManager.privacy.rawValue) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - 内购
extension SettingViewController {
    /// 终身订阅，无需 restore
    func purchaseConsumable(id: String) {
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员，无需再次购买")
            return
        }
        
        hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub?.mode = .indeterminate
        hub?.animationType = .fade
        hub?.show(animated: true)
        
        IAPManager.shared.purchaseConsumable(productID: id) { [weak self] (result) in
            self?.hub?.hide(animated: true)
            switch result {
            case .canceled:
                MessageTool.shared.showMessage(theme: .error ,title: "取消购买")
                break
            case .success(let product, let expireDate):
                MessageTool.shared.showMessage(theme: .success ,title: "购买成功！")
                CLog("购买产品id的值为: \(product.productIdentifier)")
                Defaults[.isVIP] = true
                Defaults[.isLifeTimeVIP] = true
                NotificationCenter.default.post(name: .purchaseDidSuccessed, object: nil)
                if let expire = expireDate {
                    Defaults[.subscriptionExprireDate] = expire.timeIntervalSince1970
                }
                self?.dismiss(animated: true, completion: nil)
                break
            case .networkError:
                MessageTool.shared.showMessage(theme: .error ,title: "网络出错啦", body: "请检查您的网络是否正常", duration: 3)
                break
            case .purchaseFail, .notPurchased, .expired:
                MessageTool.shared.showMessage(theme: .error ,title: "购买失败", body: "请检查网络是否正常，或再次尝试", duration: 3)
                break
            case .verifyFail(let product):
                CLog("验证失败的值为: \(product.productIdentifier)")
                MessageTool.shared.showMessage(theme: .error ,title: "验证失败", body: "请尝试「恢复购买」", duration: 3)
                break
            }
        }
    }
    
    func restoreAllPurchase() {
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已经是终身会员了！")
            return
        }
        
        if Defaults[.isVIP] {
            MessageTool.shared.showMessage(title: "您已经是会员了！")
            return
        }
        
        /// 先验证 是否是    年度会员
        /// 再验证是否是 包月会员
        
        hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub?.mode = .indeterminate
        hub?.animationType = .fade
        hub?.label.text = "恢复购买中..."
        hub?.show(animated: true)
        
        /// 是否购买成功
        var isSuccessed = false
        /// 是否是因为过期而无法恢复
        var isExpired = false
        /// 是否是因为网络原因而无法恢复
        var isNetwordError = false
        /// 是否是因为没有购买而无法恢复
        var isNotPurchased = false
        
        /// 如果不是终身会员，验证年度会员
        IAPManager.shared.restore(productID: IAPManager.ProductID.year) { [weak self] (result) in
            switch result {
            case .success(let expireDate):
                MessageTool.shared.showMessage(title: "欢迎回来~", body: "您的年度会员资格恢复成功!")
                isSuccessed = true
                // 2. 修改本地VIP属性
                Defaults[.isVIP] = true
                
                if let expire = expireDate {
                    Defaults[.subscriptionExprireDate] = expire.timeIntervalSince1970
                }
                NotificationCenter.default.post(name: .purchaseDidSuccessed, object: nil)
                // 3.处理订阅界面
                self?.dismiss(animated: true, completion: nil)
                break
            case .expired:
                isExpired = true
                break
            case .nothing:
                isNotPurchased = true
                break
            case .networkError:
                isNetwordError = true
                break
            default:
                break
            }
            if !isSuccessed {
                IAPManager.shared.restore(productID: IAPManager.ProductID.month) { [weak self] (result) in
                    switch result {
                    case .success(let expireDate):
                        MessageTool.shared.showMessage(title: "欢迎回来~", body: "您的月度会员资格恢复成功!")
                        // 2. 修改本地VIP属性
                        Defaults[.isVIP] = true
                        
                        NotificationCenter.default.post(name: .purchaseDidSuccessed, object: nil)
                        
                        if let expire = expireDate {
                            Defaults[.subscriptionExprireDate] = expire.timeIntervalSince1970
                        }
                        // 3.处理订阅界面
                        self?.dismiss(animated: true, completion: nil)
                    case .expired:
                        MessageTool.shared.showMessage(theme: .error, title: "订阅已经过期", duration: 3)
                        break
                    case .nothing:
                        MessageTool.shared.showMessage(theme: .error, title: "暂未订阅", body: "您需要先订阅才能解锁所有功能", duration: 3)
                    case .networkError:
                        MessageTool.shared.showMessage(theme: .error, title: "网络出错啦", body: "请检查您的网络是否正常", duration: 3)
                        break
                    default:
                        if isExpired {
                            MessageTool.shared.showMessage(theme: .error, title: "订阅已经过期", duration: 3)
                        } else if isNotPurchased {
                            MessageTool.shared.showMessage(theme: .error, title: "暂未订阅", body: "您需要先订阅才能解锁所有功能", duration: 3)
                        } else if isNetwordError {
                            MessageTool.shared.showMessage(theme: .error, title: "网络出错啦", body: "请检查您的网络是否正常", duration: 3)
                        } else {
                            MessageTool.shared.showMessage(theme: .error, title: "恢复失败", body: "请再次尝试，或者在「个人」界面中反馈问题", duration: 3)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ************ 个人设置事件 ************
extension SettingViewController {
    func chooseAvatar() {
        AnalysisTool.shared.logEvent(event: "设置-头像按钮")
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photosStatus {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker = UIImagePickerController()
                picker?.delegate = self
                picker?.sourceType = .photoLibrary
                picker?.allowsEditing = true
                present(picker!, animated: true, completion: nil)
            } else {
                CLog("图片不支持")
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.picker = UIImagePickerController()
                            strongSelf.picker?.delegate = self
                            strongSelf.picker?.sourceType = .photoLibrary
                            strongSelf.present(strongSelf.picker!, animated: true, completion: nil)
                        }
                    } else {
                        CLog("不支持选取图片")
                    }
                }
            }
        default:
            let alert = UIAlertController(title: "温馨提示", message: "您还未开启相册权限，无法选择照片", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "前往设置", style: .default, handler: {
                ACTION in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                                    CLog("开启设置")
                        })
                    } else {
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                        
                    }
                })
            })
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            CLog("用户拒绝了相册授权")
        }
    }
    
    func rename() {
        AnalysisTool.shared.logEvent(event: "设置-昵称按钮")
        let alert = UIAlertController(title: "昵称", message: "", preferredStyle: .alert)
        
        alert.addTextField{(usernameText) ->Void in
            usernameText.placeholder = "昵称"
            usernameText.text = self.userInfo.name
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    UserInfoAPI.saveUserInfo(userInfo: ["name": text])
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeDiscription() {
        AnalysisTool.shared.logEvent(event: "设置-描述按钮")
        let alert = UIAlertController(title: "个性签名", message: "", preferredStyle: .alert)
        
        alert.addTextField { [weak self] (usernameText) ->Void in
            usernameText.placeholder = "个性签名"
            usernameText.text = self?.userInfo.motto
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    UserInfoAPI.saveUserInfo(userInfo: ["motto": text])
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UI 界面
extension SettingViewController {
    func setupUI() {
        setupBg()
        setupUserInfo()
        setupUserSettings()
        setupPurchase()
        setupAbout()
    }
    
    func setupAbout() {
        _ = aboutContaier.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(purchaseContainer.snp.bottom).offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(4 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
                $0.bottom.equalTo(contentView.snp.bottom).offset(-100)
            }
        }
        
        for (index, cell) in [helpCell, rateCell, shareCell,  aboutCell].enumerated() {
            _ = cell.then {
                aboutContaier.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(SettingCellModel.cellHeight)
                    $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                }
            }
        }
        
        helpCell.initData(leftText: "帮助文档", isRightArrowIcon: true) { [weak self] in
            self?.showHelpDocment()
        }
        
        rateCell.initData(leftText: "App Store 好评鼓励", isRightArrowIcon: true) { [weak self] in
            self?.showRate()
        }
        
        shareCell.initData(leftText: "分享给好友", isRightArrowIcon: true) { [weak self] in
            self?.share()
        }
        
        aboutCell.initData(leftText: "关于我们", isBorder: false, isRightArrowIcon: true) { [weak self] in
            self?.showAbout()
        }
    }
    
    func setupPurchase() {
        _ = purchaseContainer.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(settingContainer.snp.bottom).offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(5 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
            }
        }
        
        for (index, cell) in [subscriptionCell, restoreCell, restoreLifetimeCell, termsCell, policyCell].enumerated() {
            _ = cell.then {
                purchaseContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(SettingCellModel.cellHeight)
                    $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                }
            }
        }
        
        subscriptionCell.initData(leftText: "高级版", isRightArrowIcon: true) { [weak self] in
            self?.showSubscription()
        }
        
        restoreCell.initData(leftText: "恢复购买", isRightArrowIcon: true) { [weak self] in
            self?.restore()
        }
        
        restoreLifetimeCell.initData(leftText: "恢复终身会员资格", isRightArrowIcon: true) { [weak self] in
            self?.restoreLifetime()
        }
        
        termsCell.initData(leftText: "使用协议", isRightArrowIcon: true) { [weak self] in
            self?.showTerms()
        }
        
        policyCell.initData(leftText: "隐私政策", isBorder: false, isRightArrowIcon: true) { [weak self] in
            self?.showPolicy()
        }
    }
    
    func setupUserSettings() {
        _ = settingContainer.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(userContainer.snp.bottom).offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(4 * SettingCellModel.cellHeight + 3 * SettingCellModel.spacing)
            }
        }
        
        for (index, cell) in [reminderCell, imageQualityCell, passwordCell, exportDiaryCell].enumerated() {
            _ = cell.then {
                settingContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(SettingCellModel.cellHeight)
                    $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                }
            }
        }
        
        reminderCell.initData(leftText: "设置提醒", isRightArrowIcon: true) { [weak self] in
            let vc = ReminderViewController()
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        setReminder()
        
        let index = Defaults[.imageQuality]
        imageQualityCell.initData(leftText: "日记图片质量", rightText: ImageQuality.all[index].name) { [weak self] in
            self?.showChooseImageQuality()
        }
        
        passwordCell.initData(leftText: "启动页锁屏(Face ID)", isRightSwitch: true) {}
        passwordCell.rightSwitch.addTarget(self, action: #selector(setLaunchScreenPassword), for: .valueChanged)
        
        exportDiaryCell.initData(leftText: "导出日记", isBorder: false, isRightArrowIcon: true) { [weak self] in
            AnalysisTool.shared.logEvent(event: "设置-导出日记")
            let vc = ExportDiaryViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupUserInfo() {
        _ = userContainer.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview().offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(3 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
            }
        }
        
        for (index, cell) in [avatarCell, nameCell, discriptionCell].enumerated() {
            _ = cell.then {
                userContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(SettingCellModel.cellHeight)
                    $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                }
            }
        }
    }
    
    func setupBg() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = hearerContainer.then {
            $0.initData(title: "设置") { [weak self] in
                (self?.navigationController?.tabBarController as? TabBarViewController)?.showTabbar()
                self?.navigationController?.popViewController(animated: true)
            }
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(CustomNavigationBar.height)
            }
        }
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(hearerContainer.snp.bottom)
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
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

