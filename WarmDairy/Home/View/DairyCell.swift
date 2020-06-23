//
//  DairyCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/19.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import WebKit
import SwiftDate

class DairyCellFrame {
    static var headerHeight = 44
    static var titleHeight = 44
    static var bottomSpacing = 12
}

class DairyCell: UIView {
    
    weak var delegate: TodayDairyViewController?
    
    /// 用户是否手动解锁了
    var isManualUnlocked: Bool = false
    
    lazy var dairy = DairyModel()
    
    lazy var headerView = UIView()
    lazy var timeLabel = UILabel()
    lazy var weatherView = UIImageView()
    lazy var locationButton = UIButton()
    lazy var moodView = UIImageView()
    lazy var loveButton = UIButton()
    lazy var editButton = UIButton()
    lazy var lockButton = UIButton()
    
    lazy var mainView = UIView()
    lazy var titleLabel = UILabel()
    lazy var webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    /// 初始化
    /// - Parameters:
    ///   - dairy: dairy
    ///   - isManualUnlocked: 是否手动解锁了
    func initData(dairy: DairyModel, isManualUnlocked: Bool = false) {
        self.dairy = dairy
        self.isManualUnlocked = isManualUnlocked
        layer.borderColor = UIColor(hexString: dairy.bgColor, alpha: 0.8)?.cgColor
        mainView.backgroundColor = UIColor(hexString: dairy.bgColor, alpha: 0.8)
        timeLabel.text = dairy.createdAt.toFormat("a hh:mm", locale: Locales.chineseSimplified)
        titleLabel.text = dairy.title == "" ? "标题" : dairy.title
        
        if dairy.isLocked && !isManualUnlocked {
            /// 如果没有手动解锁，则都不显示
            lockButton.snp.makeConstraints {
                $0.width.equalTo(DairyCellFrame.headerHeight)
            }
            return
        } else {
            lockButton.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        }
        
        editButton.isHidden = false
        loveButton.isHidden = false
        moodView.isHidden = false
        locationButton.isHidden = false
        weatherView.isHidden = false
        
        if dairy.isLocked {
            editButton.snp.makeConstraints {
                $0.right.equalTo(lockButton.snp.left)
            }
        } else {
            editButton.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-10)
            }
        }
        
        if dairy.cateIds != "" {
            loveButton.setImage(R.image.icon_editor_love_selected(), for: .normal)
            loveButton.snp.makeConstraints {
                $0.width.equalTo(DairyCellFrame.headerHeight)
            }
        } else {
            loveButton.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        }
        
        if dairy.mood == "" {
            moodView.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        } else {
            moodView.image = UIImage(named: "icon_mood_\(dairy.mood)")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
            moodView.snp.makeConstraints {
                $0.width.equalTo(DairyCellFrame.headerHeight)
            }
        }
        
        if dairy.location == "" {
            locationButton.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        } else {
            locationButton.setImage(R.image.icon_editor_location_selected(), for: .normal)
            locationButton.snp.makeConstraints {
                $0.width.equalTo(DairyCellFrame.headerHeight)
            }
        }
        
        if dairy.weather == "" {
            weatherView.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        } else {
            weatherView.image = UIImage(named: "icon_weather_\(dairy.weather)")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
            weatherView.snp.makeConstraints {
                $0.width.equalTo(DairyCellFrame.headerHeight)
            }
        }
        
        // webview 加载
        let start = "<!DOCTYPE html><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no\"><meta charset=\"UTF-8\"><style media=\"screen\">img {width: 80%;margin: 8px 10%; border-radius:8px;}</style></head><body>"
        //            /private/var/mobile/Containers/Data/Application/08B46C47-7B84-4EE3-B843-D1CBFA323647/tmp/editor/images/com.qinguanghui.WarmDairy158459331895986"
        let end = "</body>"
        let str = start + dairy.content + end
        
        _ = webView.then {
            $0.navigationDelegate = self
            let url = URL(fileURLWithPath: FileManager.tmpPath + DairyImageAPI.imagePath + "/")
            $0.loadHTMLString(str, baseURL: url)
        }
    }
}

// MARK: - 事件处理
extension DairyCell {
    @objc func showEdit() {
        delegate?.currentAnimateCellIndex = tag
        delegate?.editDairy(dairy: dairy)
    }
    
    @objc func unlockDairy() {
        // 如果已经手动解锁 则不再解锁
        if isManualUnlocked { return }
        delegate?.unlockDairyCell(at: tag)
    }
    
    //    @objc func showCate() {
    //        let vc = CategoryChooserViewController()
    //        vc.initData(cateIds: dairy.cateIds)
    //        delegate?.present(vc, animated: true, completion: nil)
    //    }
}

// MARK: - webview delegate 用于检测高度，更新相关UI
extension DairyCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (value, error) in
            guard let self = self else { return }
            if let value = value as? Int {
                self.delegate?.updateDairyCell(at: self.tag, webViewHeight: value, isManualUnlocked: self.isManualUnlocked)
            }
        }
    }
}

extension DairyCell {
    func setupUI() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 10
        layer.borderWidth = 1
        clipsToBounds = true
        setupHeader()
        setupContent()
    }
    
    func setupContent() {
        _ = mainView.then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
            }
        }
        
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            mainView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.right.equalToSuperview().offset(-12)
                $0.height.equalTo(DairyCellFrame.titleHeight)
            }
        }
        
        _ = webView.then {
            $0.scrollView.isScrollEnabled = false
            $0.isOpaque = false
            $0.backgroundColor = .clear
            $0.scrollView.backgroundColor = .clear
            
            mainView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.right.equalToSuperview().offset(-12)
                $0.bottom.equalToSuperview().offset(-DairyCellFrame.bottomSpacing)
                $0.top.equalToSuperview().offset(DairyCellFrame.titleHeight)
            }
        }
    }
    
    func setupHeader() {
        _ = headerView.then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.4)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(DairyCellFrame.headerHeight)
            }
        }
        
        _ = UIVisualEffectView().then {
            $0.effect = UIBlurEffect(style: .regular)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = timeLabel.then {
            $0.textColor = UIColor(hexString: "ffffff")
            $0.font = UIFont.systemFont(ofSize: 16)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
            }
        }
        
        _ = lockButton.then {
            $0.setImage(R.image.icon_today_locked(), for: .normal)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-10)
                $0.height.equalTo(DairyCellFrame.headerHeight)
            }
            $0.addTarget(self, action: #selector(unlockDairy), for: .touchUpInside)
        }
        
        _ = editButton.then {
            $0.isHidden = true
            $0.setImage(R.image.icon_today_edit(), for: .normal)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(DairyCellFrame.headerHeight)
            }
            $0.addTarget(self, action: #selector(showEdit), for: .touchUpInside)
        }
        
        _ = loveButton.then {
            $0.isHidden = true
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(editButton.snp.left)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(DairyCellFrame.headerHeight)
            }
        }
        
        _ = moodView.then {
            $0.isHidden = true
            $0.contentMode = .scaleAspectFill
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(DairyCellFrame.headerHeight)
                $0.centerY.equalToSuperview()
                $0.right.equalTo(loveButton.snp.left)
            }
        }
        
        _ = locationButton.then {
            $0.isHidden = true
            $0.contentMode = .scaleAspectFill
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(DairyCellFrame.headerHeight)
                $0.centerY.equalToSuperview()
                $0.right.equalTo(moodView.snp.left)
            }
        }
        
        _ = weatherView.then {
            $0.isHidden = true
            $0.contentMode = .scaleAspectFill
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(DairyCellFrame.headerHeight)
                $0.centerY.equalToSuperview()
                $0.right.equalTo(locationButton.snp.left)
            }
        }
    }
}
