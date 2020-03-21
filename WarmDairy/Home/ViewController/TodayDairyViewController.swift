//
//  TodayDairyViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/16.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import RQShineLabel
import SwiftDate
import WebKit

class TodayDairyViewController: UIViewController {
    
    lazy var mottoData = MottoModel()
    lazy var dairesData = [DairyModel]()
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var bgImage = UIImageView()
    lazy var bgMask = UIView()
    lazy var backButton = UIButton()
    lazy var dayLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var weekLabel = UILabel()
    lazy var dateLine = UIView()
    lazy var mottoLabel = RQShineLabel()
    lazy var authorLabel = UILabel()
    lazy var lineView = UIView()
    
    lazy var dairyContainers = [UIView]()
    lazy var dairyCells = [DairyCell]()
    
    lazy var editButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .dairyDidAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mottoLabel.shine()
    }
    
    func initData(mottoData: MottoModel) {
        self.mottoData = mottoData
        bgImage.kf.setImage(with: URL(string: mottoData.imageURL))
        mottoLabel.text = mottoData.motto
        authorLabel.text = mottoData.author
        mottoLabel.text = mottoData.motto
        dayLabel.text = mottoData.date.toFormat("dd")
        dateLabel.text = mottoData.date.toFormat("MMM yyyy")
        weekLabel.text = mottoData.date.weekdayName(.default, locale: Locales.chineseSimplified)
        loadData()
    }
    
    @objc func loadData() {
        DairyAPI.getDairy(date: mottoData.date) { (dairies) in
            print("测试 ===> today dairies的值为: \(dairies)")
            self.dairesData = dairies
            self.setupDairyView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dairyDidAdded, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil)
    }
}

// MARK: - 事件处理
extension TodayDairyViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showEditor() {
        let vc = EditorViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.initBg(image: mottoData.imageURL)
        present(vc, animated: true, completion: nil)
    }
    
    func editDairy(dairy: DairyModel) {
        let vc = EditorViewController()
        vc.initData(dairy: dairy)
        vc.initBg(image: mottoData.imageURL)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func updateDairyCell(at index: Int, webViewHeight: Int) {
        dairyCells[index].snp.updateConstraints {
            let otherHeight = DairyCellFrame.headerHeight + DairyCellFrame.titleHeight + DairyCellFrame.bottomSpacing
            $0.height.equalTo(otherHeight + webViewHeight + 16)
        }
        dairyCells[index].layoutIfNeeded()
    }
}

// MARK: - UI 界面
extension TodayDairyViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        setupBack()
        setupDate()
        setupMotto()
        
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
                $0.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-24)
                $0.width.height.equalTo(64)
            }
            $0.addTarget(self, action: #selector(showEditor), for: .touchUpInside)
        }
    }
    
    func setupDairyView() {
        // 先重置view
        if dairyCells.count > 0 {
            for dairyCell in dairyCells {
                dairyCell.removeFromSuperview()
            }
            dairyCells = [DairyCell]()
        }
        
        for (index, dairy) in dairesData.enumerated() {
            let dairyCell = DairyCell().then {
                $0.initData(dairy: dairy)
                $0.delegate = self
                $0.tag = index
                contentView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(12)
                    $0.right.equalToSuperview().offset(-12)
                    if index == 0 {
                        $0.top.equalToSuperview().offset(240)
                    } else {
                        $0.top.equalTo(dairyCells[dairyCells.count - 1].snp.bottom).offset(32)
                    }
                    $0.height.equalTo(DairyCellFrame.headerHeight + DairyCellFrame.titleHeight + DairyCellFrame.bottomSpacing)
                }
            }
            dairyCells.append(dairyCell)
            
            if index == dairesData.count - 1 {
                contentView.snp.makeConstraints {
                    $0.bottom.equalTo(dairyCell.snp.bottom).offset(64)
                }
            }
        }
    }
    
    func setupMotto() {
        
        _ = mottoLabel.then {
            $0.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 1)
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(32)
                $0.width.equalTo(DeviceInfo.screenWidth * 0.8)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        _ = authorLabel.then {
            $0.font = UIFont.systemFont(ofSize: 10)
            $0.textColor = UIColor(hexString: "ffffff", alpha: 0.8)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(mottoLabel.snp.bottom).offset(20)
                $0.right.equalToSuperview().offset(-24)
            }
        }
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(hexString: "ffffff", alpha: 0.8)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(authorLabel)
                $0.right.equalTo(authorLabel.snp.left).offset(-10)
                $0.width.equalTo(64)
                $0.height.equalTo(1)
            }
        }
        
    }
    
    func setupDate() {
        _ = dayLabel.then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 50)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.top.equalToSuperview().offset(8)
            }
        }
        
        _ = dateLine.then {
            $0.backgroundColor = UIColor(hexString: "ffffff", alpha: 0.4)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(dayLabel)
                $0.height.equalTo(44)
                $0.width.equalTo(1)
                $0.right.equalTo(dayLabel.snp.left).offset(-8)
            }
        }
        
        _ = weekLabel.then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(dateLine.snp.left).offset(-8)
                $0.top.equalTo(dateLine).offset(4)
            }
        }
        
        _ = dateLabel.then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(dateLine.snp.left).offset(-8)
                $0.bottom.equalTo(dateLine).offset(-4)
            }
        }
    }
    
    func setupBack() {
        _ = bgImage.then {
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = bgMask.then {
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.2)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(topLayoutGuide.snp.bottom)
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_today_back(), for: .normal)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.left.equalToSuperview().offset(8)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
