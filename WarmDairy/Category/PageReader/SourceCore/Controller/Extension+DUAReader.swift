//
//  Extension+DUAReader.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import ViewAnimator
import SwiftyUserDefaults

class CustonAnimation {
    static func animateHideView(view: UIView, direction: Direction, reverseDirection: Direction, offset: CGFloat) {
        let animation = AnimationType.from(direction: direction, offset: offset)
        UIView.animate(views: [view], animations: [animation], reversed: true, initialAlpha: 1, finalAlpha: 0, delay: 0, duration: 0.4, options: .curveEaseInOut)  {
            view.alpha = 0
                    let animation2 = AnimationType.from(direction: reverseDirection, offset: offset)
            UIView.animate(views: [view], animations: [animation2], reversed: true, initialAlpha: 0, finalAlpha: 0, duration: 0)
            }
    }
    
    static func animateShowView(view: UIView, direction: Direction, offset: CGFloat) {
        let animation = AnimationType.from(direction: direction, offset: offset)
        UIView.animate(views: [view], animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.4, options: .curveEaseInOut)
    }
}

extension DUAReader {
    @objc func hideSideBar() {
        addGesture()
        CustonAnimation.animateHideView(view: sideMask, direction: .left, reverseDirection: .right, offset: DeviceInfo.screenWidth * 0.7)
    }
    
    @objc func showSideBar() {
        AnalysisTool.shared.logEvent(event: "阅读器-显示目录按钮点击")
        removeGesture()
        CustonAnimation.animateShowView(view: sideMask, direction: .left, offset: DeviceInfo.screenWidth * 0.7)
    }
    
    func showBar() {
        CustonAnimation.animateShowView(view: bottomBar, direction: .bottom, offset: 100)
        CustonAnimation.animateShowView(view: topBar, direction: .top, offset: 100)
    }
    
    func hideBar() {
        CustonAnimation.animateHideView(view: bottomBar, direction: .bottom, reverseDirection: .top, offset: 100)
        CustonAnimation.animateHideView(view: topBar, direction: .top, reverseDirection: .bottom, offset: 100)
    }
    
    @objc func toggleBgColor(sender: UIButton) {
        AnalysisTool.shared.logEvent(event: "阅读器-切换背景按钮点击")
        let tag = sender.tag - 100
        config.backgroundColor = ReaderBg.all[tag]
    }
    
    @objc func share() {
        AnalysisTool.shared.logEvent(event: "阅读器-分享按钮点击")
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
    
    @objc func download() {
        AnalysisTool.shared.logEvent(event: "阅读器-下载按钮点击")
        if !Defaults[.isVIP] {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        exportDiariesToPDF(diaries: allDiaries, type: .cate, filename: "Warm Diary", isNeedImagePathReplaced: false)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

extension DUAReader {
    func setupUI() {
        setupBottomView()
        setupTopView()
        setupSideBar()
    }
    
    func setupBottomView() {
        _ = bottomBar.then {
            $0.alpha = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.bottom.right.equalToSuperview()
                $0.top.equalTo(bottomLayoutGuide.snp.top).offset(-60)
            }
        }
        
        _ = UIVisualEffectView().then {
            $0.effect = UIBlurEffect(style: .regular)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let menuButton = UIButton().then {
            $0.setImage(R.image.icon_reader_menu(), for: .normal)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.width.height.equalTo(44)
                $0.top.equalToSuperview().offset(8)
            }
            $0.addTarget(self, action: #selector(showSideBar), for: .touchUpInside)
        }
        
        // 计算剩余宽度
        let remianWidth = DeviceInfo.screenWidth - 20 - 30 - 44 - 30
        let spacing = 12
        let width = (Int(remianWidth) - 2 * spacing) / 3
        _ = UIButton().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            $0.tag = 102
            $0.backgroundColor = UIColor(hexString: ReaderBg.yellow.rawValue)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(menuButton)
                $0.right.equalToSuperview().offset(-30)
                $0.width.equalTo(width)
                $0.height.equalTo(20)
            }
            $0.addTarget(self, action: #selector(toggleBgColor), for: .touchUpInside)
        }
        _ = UIButton().then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            $0.tag = 101
            $0.backgroundColor = UIColor(hexString: ReaderBg.green.rawValue)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(menuButton)
                $0.right.equalToSuperview().offset(-30 - width - spacing)
                $0.height.equalTo(20)
                $0.width.equalTo(width)
            }
            $0.addTarget(self, action: #selector(toggleBgColor), for: .touchUpInside)
        }
        _ = UIButton().then {
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
            $0.tag = 100
            $0.backgroundColor = UIColor(hexString: ReaderBg.white.rawValue)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(menuButton)
                $0.right.equalToSuperview().offset(-30 - (width + spacing) * 2)
                $0.width.equalTo(width)
                $0.height.equalTo(20)
            }
            $0.addTarget(self, action: #selector(toggleBgColor), for: .touchUpInside)
        }
    }
    
    func setupTopView() {
        _ = topBar.then {
            $0.alpha = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(52)
            }
        }
        
        _ = UIVisualEffectView().then {
            $0.effect = UIBlurEffect(style: .regular)
            topBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let backButton = UIButton().then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            topBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(14)
                $0.width.height.equalTo(44)
                $0.bottom.equalToSuperview().offset(-6)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        let shareButton = UIButton().then {
            $0.setImage(R.image.icon_reader_share(), for: .normal)
            topBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-20)
                $0.width.height.equalTo(44)
                $0.centerY.equalTo(backButton)
            }
            $0.addTarget(self, action: #selector(share), for: .touchUpInside)
        }
        
        _ = UIButton().then {
            $0.setImage(R.image.icon_reader_download(), for: .normal)
            topBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(shareButton.snp.left)
                $0.width.height.equalTo(44)
                $0.centerY.equalTo(backButton)
            }
            $0.addTarget(self, action: #selector(download), for: .touchUpInside)
        }
    }
    
    func setupSideBar() {
        _ = sideMask.then {
            $0.alpha = 0
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = sideBar.then {
            sideMask.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.left.bottom.equalToSuperview()
                $0.width.equalTo(DeviceInfo.screenWidth * 0.7)
            }
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.5)
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideSideBar))
            $0.addGestureRecognizer(tap)
            sideMask.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.top.bottom.equalToSuperview()
                $0.left.equalTo(sideBar.snp.right)
            }
        }
        
        _ = UIVisualEffectView().then {
            $0.effect = UIBlurEffect(style: .extraLight)
            sideBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: DeviceInfo.screenWidth * 0.7 - 32, height: 32)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .vertical
            $0.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            sideBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(DeviceInfo.topSafeAreaHeight)
                $0.bottom.equalToSuperview().offset(-DeviceInfo.bottomSafeAreaHeight)
                $0.left.right.equalToSuperview()
            }
            $0.register(ChapterTitleCell.self, forCellWithReuseIdentifier: ChapterTitleCell.identifier)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DUAReader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterTitles.count
    }
}

// MARK: - UICollectionViewDelegate
extension DUAReader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterTitleCell.identifier, for: indexPath) as! ChapterTitleCell
        cell.initData(text: "\(indexPath.row + 1). \(chapterTitles[indexPath.row])")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        readChapterBy(index: indexPath.row + 1, pageIndex: 1)
        hideSideBar()
    }
}



class ChapterTitleCell: UICollectionViewCell {
    static let identifier = "ChapterTitleCell_ID"
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse()
    }
    
    func initData(text: String) {
        titleLabel.text = text
    }
}

extension ChapterTitleCell {
    func setupUI() {
        _ = titleLabel.then {
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 18)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
