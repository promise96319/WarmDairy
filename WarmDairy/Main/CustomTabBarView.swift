//
//  CustomTabBarView.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

// MARK: - 生命周期
class CustomTabBarView: UIView {
    weak var delegate: TabBarViewController?
    
    /// tabbar 实际内容高度
    static let customHeight: Int = 50
    static let tabbarHeight = CustomTabBarView.customHeight + DeviceInfo.bottomSafeAreaHeight
    
    /// tabbar 传入的参数  == 暂且写死
    var customTabBarItems = [
        "edit", "category", "user"
    ]
    /// tabbar image 数组
    var customImageViewArray = [UIImageView]()
    
    /// tabbar 容器
    lazy var contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
}

// MARK: - UI 界面
extension CustomTabBarView {
    func setupUI() {
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "FEFFFF")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
            $0.height.equalTo(CustomTabBarView.customHeight)
        }
   
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution =  .fillEqually
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(DeviceInfo.screenWidth)
        }
        
        for (index, item) in customTabBarItems.enumerated() {
            let itemStack = generateItem(name: item)
            itemStack.tag = index
            stackView.addArrangedSubview(itemStack)
        }
    }
    
    func generateItem(name: String) -> UIStackView {
        let itemStack = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }
        
        _ = UIImageView().then {
            $0.image = UIImage(named: "icon_tabbar_\(name)")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
            $0.tintColor = UIColor(hexString: "b5baca")
            
            customImageViewArray.append($0)
            itemStack.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
            }
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(click))
        itemStack.addGestureRecognizer(gesture)
        return itemStack
    }
}

// MARK: - 事件处理
extension CustomTabBarView {
    /// tabbar 点击事件
    ///
    /// - Parameter sender: 点击的目标
    @objc func click(sender: UITapGestureRecognizer) {
        toggleTabBar(index: (sender.view?.tag)!)
    }
    
    /// 根据 index 切换 tabbar
    ///
    /// - Parameter index: tabbar index
    func toggleTabBar(index: Int) {
        delegate?.selectedIndex = index
        for itemIndex in 0..<customTabBarItems.count {
            if itemIndex == index {
                customImageViewArray[itemIndex].tintColor = UIColor(hexString: "182848")
            } else {
                customImageViewArray[itemIndex].tintColor = UIColor(hexString: "b5baca")
            }
        }
    }
}
