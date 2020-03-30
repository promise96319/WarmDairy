//
//  BackgroundChooserViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/28.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults

protocol BackgroundColorChooserDelegate {
    func chooseBackground(color: String) -> Void
}

class BackgroundChooserViewController: UIViewController {
    var delegate: BackgroundColorChooserDelegate?

    var backgroundColors = ["F6E6CD", "f1f6fa", "CFFEF6",  "E6F6CD", "E6CDF6", "CDE6F6", "CDF6E6", "F6CDE6", "d1f7eb", "aacfcf",  "fde2e2", "d4ebd0"]
    
    lazy var bgImage = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton()
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func initData(bgImage: String) {
        self.bgImage.kf.setImage(with: URL(string: bgImage))
    }
}

extension BackgroundChooserViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension BackgroundChooserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundColors.count
    }
}

// MARK: - UICollectionViewDelegate
extension BackgroundChooserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BgCell.identifier, for: indexPath) as! BgCell
        let isNeedPremium = !Defaults[.isVIP] && indexPath.row >= VIPModel.backgroundCount
        cell.initData(bgColor: backgroundColors[indexPath.row], isNeedPremium: isNeedPremium)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isNeedPremium = !Defaults[.isVIP] && indexPath.row >= VIPModel.backgroundCount
        if isNeedPremium {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        
        delegate?.chooseBackground(color: backgroundColors[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI 界面
extension BackgroundChooserViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hexString: "f1f6fa")
        
        _ = bgImage.then {
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let headerView = UIView().then {
            $0.backgroundColor = UIColor(hexString: "f1f6fa")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(54)
            }
        }
        
        _ = titleLabel.then {
            $0.text = "背景颜色"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            headerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(10)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: DeviceInfo.screenWidth, height: 64)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .vertical
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0)
            $0.register(BgCell.self, forCellWithReuseIdentifier: BgCell.identifier)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

class BgCell: UICollectionViewCell {
    static let identifier = "BgCell_ID"
    
    lazy var bgView = UIView()
    lazy var premiumImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(bgColor: String, isNeedPremium: Bool = false) {
        bgView.backgroundColor = UIColor(hexString: bgColor, alpha: 0.9)
        premiumImage.isHidden = !isNeedPremium
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgView.backgroundColor = .clear
        premiumImage.isHidden = true
    }
}

extension BgCell {
    func setupUI() {
        _ = bgView.then {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = premiumImage.then {
            $0.image = R.image.icon_me_premium()
            $0.contentMode = .scaleToFill
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-12)
                $0.bottom.equalToSuperview().offset(-8)
                $0.width.height.equalTo(16)
            }
        }
    }
}
