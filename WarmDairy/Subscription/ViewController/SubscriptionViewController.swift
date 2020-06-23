//
//  SubscriptionViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/23.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import MBProgressHUD
import ViewAnimator
import SafariServices

class SubscriptionViewController: UIViewController {
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var circleView = UIView()
    lazy var bgImage = UIImageView()
    lazy var backButton = UIButton()
    lazy var logoLabel = UILabel()
    
    var sections = [UIImageView]()
    var sectionlabels = [UILabel]()
    lazy var monthButton = SubscriptionButton()
    lazy var yearButton = SubscriptionButton()
    lazy var lifetimeButton = SubscriptionButton()
    
    lazy var termsLabel = [UILabel]()
    
    var hub: MBProgressHUD?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        AnalysisTool.shared.logEvent(event: "订阅界面被打开")
        super.viewDidLoad()
        setupUI()
        let rightAni = AnimationType.from(direction: .right, offset: 60)
        let bottomAni = AnimationType.from(direction: .bottom, offset: 30)
        
        UIView.animate(views: [circleView, bgImage, logoLabel],
        animations: [bottomAni],
        initialAlpha: 0,
        finalAlpha: 1,
        delay: 0.1,
        duration: 0.6)
        
        for (index, section) in sections.enumerated() {
            UIView.animate(views: [section, sectionlabels[index]],
                animations: [rightAni, bottomAni],
                initialAlpha: 0,
                finalAlpha: 1,
                delay: 0.2 + Double(index) * 0.06,
                duration: 0.6)
        }
        
        for (index, button) in [monthButton, yearButton, lifetimeButton].enumerated() {
            UIView.animate(views: [button],
            animations: [rightAni, bottomAni],
            initialAlpha: 0,
            finalAlpha: 1,
            delay: 0.56 + Double(index) * 0.06,
            duration: 0.6)
        }
        
        for (index, term) in termsLabel.enumerated() {
            UIView.animate(views: [term],
            animations: [rightAni, bottomAni],
            initialAlpha: 0,
            finalAlpha: 1,
            delay: 0.74 + Double(index) * 0.06,
            duration: 0.6)
        }
    }
}

extension SubscriptionViewController {
    @objc func goBack() {
        AnalysisTool.shared.logEvent(event: "goback退出订阅")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func monthSubscription() {
        AnalysisTool.shared.logEvent(event: "订阅-月订阅点击")
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员了，无需再次购买~")
            return
        }
        purchaseProduct(id: IAPManager.ProductID.month)
    }
    
    @objc func yearSubscription() {
        AnalysisTool.shared.logEvent(event: "订阅-年订阅点击")
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员了，无需再次购买~")
            return
        }
        purchaseProduct(id: IAPManager.ProductID.year)
    }
    
    @objc func lifetimeSubscription() {
        AnalysisTool.shared.logEvent(event: "订阅-终身订阅点击")
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员了，无需再次购买~")
            return
        }
        purchaseConsumable(id: IAPManager.ProductID.lifetime)
    }
    
    @objc func restore() {
        AnalysisTool.shared.logEvent(event: "订阅-恢复购买点击")
        if Defaults[.isLifeTimeVIP] {
            MessageTool.shared.showMessage(title: "您已是终身会员了，无需再次购买~")
            return
        }
        restoreAllPurchase()
    }
    
    @objc func showTerms() {
        AnalysisTool.shared.logEvent(event: "订阅-使用协议点击")
        if let url = URL(string: URLManager.terms.rawValue) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func showPolicy() {
        AnalysisTool.shared.logEvent(event: "订阅-隐私政策点击")
        if let url = URL(string: URLManager.privacy.rawValue) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - 内购
extension SubscriptionViewController {
    func purchaseProduct(id: String) {
        hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub?.mode = .indeterminate
        hub?.animationType = .fade
        hub?.show(animated: true)
        
        IAPManager.shared.purchaseAutoRenewable(productID: id) { [weak self] (result) in
            self?.hub?.hide(animated: true)
            switch result {
            case .canceled:
                break
            case .success(let product, let expireDate):
                var mdesription = "月度"
                if id == IAPManager.ProductID.year {
                    mdesription = "年度"
                    AnalysisTool.shared.logEvent(event: "订购界面-年订阅成功")
                } else {
                    AnalysisTool.shared.logEvent(event: "订阅界面-月订阅成功")
                }
                MessageTool.shared.showMessage(theme: .success ,title: "购买成功！", body: "您已是 Warm Diary 的\(mdesription)会员了~")
                CLog("购买产品id的值为: \(product.productIdentifier)")
                Defaults[.isVIP] = true
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
                AnalysisTool.shared.logEvent(event: "订阅界面-终身会员订阅成功")
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
        
        /// 验证年度会员
        IAPManager.shared.restore(productID: IAPManager.ProductID.year) { [weak self] (result) in
            CLog("result的值为: \(result)")
            switch result {
            case .success(let expireDate):
                self?.hub?.hide(animated: true)
                MessageTool.shared.showMessage(title: "欢迎回来~", body: "您的年度会员资格恢复成功!")
                isSuccessed = true
                // 2. 修改本地VIP属性
                Defaults[.isVIP] = true
                
                if let expire = expireDate {
                    Defaults[.subscriptionExprireDate] = expire.timeIntervalSince1970
                }
                NotificationCenter.default.post(name: .purchaseDidSuccessed, object: nil)
                CLog("年度会员到期时间: \(expireDate)")
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
            
            CLog("is的值为: \(isSuccessed)")
            if !isSuccessed {
                IAPManager.shared.restore(productID: IAPManager.ProductID.month) { [weak self] (result) in
                    self?.hub?.hide(animated: true)
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

extension SubscriptionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "showTerms" {
            showTerms()
        } else if URL.absoluteString == "showPolicy" {
            showPolicy()
        } else if URL.absoluteString == "restore" {
            restore()
        }
        return true
    }
}

extension SubscriptionViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        setupBg()
        setupCheckItems()
        setupSubsciptionButtons()
        setupTerms()
    }
    
    func setupTerms() {
        let terms = [
            "「自动订购会员说明」",
            "1. 服务名称：Warm Diary 会员连续包月（1个月）、Warm Diary 会员连续包年（12个月）、Warm Diary 终身会员。",
            "2. 价格：连续包月产品\(Defaults[.monthPrice])/月，连续包年产品\(Defaults[.yearPrice])/年，终身会员\(Defaults[.lifetimePrice])（只付一次） 。",
            "3. 购买自动订阅会员的账号，会在每个计费周期到期的前24个小时，向您的iTunes账户扣费，扣费成功后顺延一个订阅周期。购买终身会员的账号，只会向您的iTunes账号扣一次费用。",
            "4. 如需取消订阅，您可以在系统「设置」 - 「iTunes Store 与 App Store」- 「Apple ID」里进行退订。如未在订阅期结束的至少24小时前关闭订阅的，将视为您同意继续授权，此订阅将会自动续订。",
            "5.如果您已购买终身会员，可以再次点击购买终身会员（免费购买）进行恢复终身会员资格",
            "6.如果您是订阅，可以点击「恢复购买」进行恢复。",
            "7.更多条款，参见：《隐私政策》、《使用协议》。",
        ]
        
        let termsPolicy = UITextView()
        let restoreView = UITextView()
        
        for (index, term) in terms.enumerated() {
            if index == 7 {
                _ = termsPolicy.then {
                    $0.isEditable = false
                    $0.isScrollEnabled = false
                    $0.backgroundColor = .clear
                    $0.textContainerInset = .zero
                    $0.font = UIFont.systemFont(ofSize: 12)
                    $0.textContainer.lineFragmentPadding = 0
                    $0.delegate = self
                    let text = NSMutableAttributedString(string: term)
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "909399")!, range: NSRange(location: 0, length: term.count))
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "409EFF")!, range: NSRange(location: 10, length: 6))
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "409EFF")!, range: NSRange(location: 17, length: 6))
                    text.addAttribute(NSAttributedString.Key.link, value: "showPolicy", range: NSRange(location: 10, length: 6))
                    text.addAttribute(NSAttributedString.Key.link, value: "showTerms", range: NSRange(location: 17, length: 6))
                    $0.attributedText = text
                    contentView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(SubscriptionFrameModel.policyHeight)
                        $0.left.equalToSuperview().offset(32)
                        $0.right.equalToSuperview().offset(-32)
                        $0.top.equalTo(restoreView.snp.bottom).offset(12)
                    }
                }
            } else if index == 6 {
                _ = restoreView.then {
                    $0.isEditable = false
                    $0.isScrollEnabled = false
                    $0.backgroundColor = .clear
                    $0.textContainer.lineFragmentPadding = 0
                    $0.textContainerInset = .zero
                    $0.font = UIFont.systemFont(ofSize: 12)
                    $0.delegate = self
                    let text = NSMutableAttributedString(string: term)
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "909399")!, range: NSRange(location: 0, length: term.count))
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "409EFF")!, range: NSRange(location: 13, length: 6))
                    text.addAttribute(NSAttributedString.Key.link, value: "restore", range: NSRange(location: 13, length: 6))
                    $0.attributedText = text
                    contentView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(SubscriptionFrameModel.restoreHeight)
                        $0.left.equalToSuperview().offset(32)
                        $0.right.equalToSuperview().offset(-32)
                        $0.top.equalTo(termsLabel[index - 1].snp.bottom).offset(12)
                        $0.bottom.equalTo(contentView).offset(-64)
                    }
                }
            } else {
                _ = UILabel().then {
                    $0.text = term
                    $0.textColor = UIColor(hexString: "909399")
                    $0.font = UIFont.systemFont(ofSize: 12)
                    $0.numberOfLines = 0
                    $0.lineBreakMode = .byWordWrapping
                    termsLabel.append($0)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints {
                        
                        $0.left.equalToSuperview().offset(32)
                        $0.right.equalToSuperview().offset(-32)
                        if index == 0 {
                            $0.top.equalTo(lifetimeButton.snp.bottom).offset(16)
                        } else {
                            $0.top.equalTo(termsLabel[index - 1].snp.bottom).offset(12)
                        }
                    }
                }
            }
        }
    }
    
    func setupSubsciptionButtons() {
        _ = monthButton.then {
            $0.alpha = 0
            $0.initData(leftText: "一个月", rightText: Defaults[.monthPrice]) { [weak self] in
                self?.monthSubscription()
            }
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(sections[sections.count - 1].snp.bottom).offset(40)
                $0.left.equalToSuperview().offset(32)
                $0.right.equalToSuperview().offset(-32)
                $0.width.equalTo(DeviceInfo.screenWidth - 64)
                $0.height.equalTo(SubscriptionFrameModel.buttonHeight)
            }
        }
        
        _ = yearButton.then {
            $0.alpha = 0
            $0.initData(leftText: "一年", rightText: Defaults[.yearPrice]) { [weak self] in
                self?.yearSubscription()
            }
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(monthButton.snp.bottom).offset(14)
                $0.left.equalToSuperview().offset(32)
                $0.right.equalToSuperview().offset(-32)
                $0.width.equalTo(DeviceInfo.screenWidth - 64)
                $0.height.equalTo(SubscriptionFrameModel.buttonHeight)
            }
        }
        
        _ = lifetimeButton.then {
            $0.alpha = 0
            $0.initData(leftText: "终身", rightText: Defaults[.lifetimePrice]) { [weak self] in
                self?.lifetimeSubscription()
            }
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(yearButton.snp.bottom).offset(14)
                $0.left.equalToSuperview().offset(32)
                $0.right.equalToSuperview().offset(-32)
                $0.width.equalTo(DeviceInfo.screenWidth - 64)
                $0.height.equalTo(SubscriptionFrameModel.buttonHeight)
            }
        }
    }
    
    func setupCheckItems() {
        let checkItems = [
            "12个精选心情图标",
            "每篇日记图片上传无限制",
            "日记同步iCloud并导出pdf",
            "完整的富文本编辑功能",
            "无限制创建日记分类和位置",
            "现有和后续更新的所有功能",
        ]
        
        for (index, item) in checkItems.enumerated() {
            let checkImage = UIImageView().then {
                $0.alpha = 0
                $0.image = R.image.icon_subcription_check()
                $0.contentMode = .scaleAspectFill
                sections.append($0)
                contentView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(SubscriptionFrameModel.checkCellHeight)
                    $0.left.equalToSuperview().offset(SubscriptionFrameModel.checkCellLeftSpaing)
                    if index == 0 {
                        $0.top.equalToSuperview().offset(80)
                    } else {
                        $0.top.equalTo(sections[index - 1].snp.bottom).offset(SubscriptionFrameModel.checkCellSpacing)
                    }
                }
            }
            
            _ = UILabel().then {
                $0.alpha = 0
                sectionlabels.append($0)
                $0.textColor = UIColor(hexString: "303133")
                $0.font = UIFont.systemFont(ofSize: SubscriptionFrameModel.checkCellFontSize)
                let text = NSMutableAttributedString(string: item)
                text.addAttribute(NSAttributedString.Key.kern, value: 0.4, range: NSRange(location: 0, length: item.count - 1))
                $0.attributedText = text
                contentView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.equalTo(checkImage.snp.right).offset(10)
                    $0.centerY.equalTo(checkImage)
                    $0.right.equalToSuperview().offset(-24)
                }
            }
        }
    }
    
    func setupBg() {
        _ = scrollView.then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalToSuperview().offset(SubscriptionFrameModel.headerMinHeight)
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
        
        _ = circleView.then {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = SubscriptionFrameModel.bgViewRadius
            $0.clipsToBounds = true
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(SubscriptionFrameModel.bgViewRadius * 2)
                $0.bottom.equalTo(view.snp.top).offset(SubscriptionFrameModel.headerMaxHeight)
            }
        }
        
        _ = bgImage.then {
            $0.image = R.image.image_subscription_bg()
            $0.contentMode = .scaleAspectFill
            circleView.addSubview($0)
            $0.snp.makeConstraints {
                
                $0.height.equalTo(SubscriptionFrameModel.headerMaxHeight)
                $0.width.equalTo(DeviceInfo.screenWidth)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        _ = logoLabel.then {
            $0.text = "Warm Diary"
            $0.textColor = UIColor(hexString: "FFFFFF")
            $0.font = UIFont(name: FontName.DS.bold.rawValue, size: 42)
            circleView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-64)
            }
        }
        
        let backView = UIView().then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            $0.clipsToBounds = true
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(32)
                if DeviceInfo.isIphoneX {
                    $0.top.equalTo(topLayoutGuide.snp.bottom)
                } else {
                    $0.top.equalTo(topLayoutGuide.snp.bottom).offset(12)
                }
                $0.left.equalToSuperview().offset(12)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_subscription_close(), for: .normal)
            backView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
