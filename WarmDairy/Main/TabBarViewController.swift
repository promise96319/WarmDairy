//
//  TabBarViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.

import UIKit

// MARK: - 自定义tabbar
class TabBarViewController: UITabBarController {
    
    lazy var tabbar = UIView()
    
    /// tabbar 传入的参数  == 暂且写死
    var customTabBarItems = [
        "edit", "category", "user"
    ]
    /// tabbar image 数组
    var customImageViewArray = [UIImageView]()
    
    /// tabbar 容器
    lazy var contentView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubViewControllers()
        toggleTabBar(index: 0)
    }
}

extension TabBarViewController {
    func hideTabbar() {
        CustonAnimation.animateHideView(view: tabbar, direction: .bottom, reverseDirection: .top, offset: 100)
    }
    
    func showTabbar() {
        CustonAnimation.animateShowView(view: tabbar, direction: .bottom, offset: 100)
    }
    
    @objc func click(sender: UITapGestureRecognizer) {
        toggleTabBar(index: (sender.view?.tag)!)
    }
    
    /// 根据 index 切换 tabbar
    ///
    /// - Parameter index: tabbar index
    func toggleTabBar(index: Int) {
        selectedIndex = index
        for itemIndex in 0..<customTabBarItems.count {
            if itemIndex == index {
                customImageViewArray[itemIndex].tintColor = UIColor(hexString: "182848")
            } else {
                customImageViewArray[itemIndex].tintColor = UIColor(hexString: "b5baca")
            }
        }
    }
}

// MARK: - 界面初始化
extension TabBarViewController {
    func setupUI() {
        tabBar.isHidden = true
        
        view.addSubview(tabbar)
        tabbar.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(CustomTabBarView.tabbarHeight)
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "FEFFFF")
            tabbar.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        tabbar.addSubview(contentView)
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


// MARK: - 添加子控制器
extension TabBarViewController {
    func addSubViewControllers() {
        var viewControllers = [UIViewController]()
        viewControllers.append(navigationController(rootViewController: HomeViewController()))
        viewControllers.append(navigationController(rootViewController: CategoryViewController(), isNavBarHidden: false))
        viewControllers.append(navigationController(rootViewController: MeViewController()))
        self.viewControllers = viewControllers
    }
    
    func navigationController(rootViewController: UIViewController, isNavBarHidden: Bool = true) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        if isNavBarHidden {
            navigationVC.setNavigationBarHidden(true, animated: false)
            navigationVC.navigationBar.isTranslucent = false
        }
        return navigationVC
    }
}

