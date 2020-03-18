//
//  TodayDairyViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/16.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import RQShineLabel
import DTCoreText

class TodayDairyViewController: UIViewController {
    
    lazy var mottoData = MottoModel()
    lazy var dariesData = [DairyModel]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        dayLabel.text = mottoData.date.day < 10 ? "0\(mottoData.date.day)" : "\(mottoData.date.day)"
        dateLabel.text = mottoData.date.toFormat("MMM yyyy")
        weekLabel.text = mottoData.date.weekday.toWeek()
        loadData()
    }
    
    @objc func loadData() {
        DairyAPI.getDairy(date: mottoData.date) { (dairies) in
            print("测试 ===> dairies的值为: \(dairies)")
            self.dariesData = dairies
            self.setupDairyView()
        }
    }
}

// MARK: - 事件处理
extension TodayDairyViewController {
    @objc func goBack() {
        print("测试 ===> click的值为: \(2222)")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editDairy(sender: UIButton) {
        let tag = sender.tag
        let vc = EditorViewController()
        vc.initData(dairy: dariesData[tag])
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UI 界面
extension TodayDairyViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        setupBack()
        setupDate()
        setupMotto()
    }
    
    func setupDairyView() {
        for (index, dairy) in dariesData.enumerated() {
            let container = UIView().then {
                $0.backgroundColor = UIColor(hexString: dairy.bgColor, alpha: 0.9)
                $0.layer.cornerRadius = 12
                $0.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
                $0.layer.shadowOpacity = 0.2
                $0.layer.shadowOffset = CGSize(width: 2, height: 4)
                $0.layer.shadowRadius = 10
                dairyContainers.append($0)
                contentView.addSubview($0)
            }
            
            _ = UIButton().then {
                $0.setTitle("看看谁什么样", for: .normal)
                $0.backgroundColor = .systemPink
                container.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.top.equalToSuperview()
                    $0.height.equalTo(100)
                }
                $0.tag = index
                $0.addTarget(self, action: #selector(editDairy), for: .touchUpInside)
            }
            
            let str = "<!DOCTYPE html><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no\"><meta charset=\"UTF-8\"></head>"
            
            guard let htmlData = (str + dairy.content).data(using: .utf8) else {return}
            
            if let attributedString = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                print("测试 ===> attr的值为: \(attributedString)")
                _ = UITextView().then {
                    $0.attributedText = attributedString
//                    $0.numberOfLines = 0
//                    $0.lineBreakMode = .byWordWrapping
                    container.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.left.top.equalToSuperview().offset(24)
                        $0.bottom.right.equalToSuperview().offset(-24)
                    }
                }
//                _ = DTAttributedLabel().then {
//                    $0.attributedString = attributedString
//                    container.addSubview($0)
//                    $0.snp.makeConstraints {
//                        $0.left.top.equalToSuperview().offset(24)
//                        $0.bottom.right.equalToSuperview().offset(-24)
//                    }
//                }
            }
            
            container.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
                $0.height.equalTo(800)
                if index == 0 {
                    $0.top.equalToSuperview().offset(240)
                } else {
                    $0.top.equalTo(dairyContainers[index-1].snp.bottom).offset(24)
                }
            }
            
            if index == dariesData.count - 1 {
                contentView.snp.makeConstraints {
                    $0.bottom.equalTo(container.snp.bottom).offset(64)
                }
            }
            
        }
    }
    
    func setupMotto() {
        
        _ = mottoLabel.then {
            $0.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 1)
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
