//
//  TabBarViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/15.
//  Copyright © 2020 qinguanghui. All rights reserved.

import UIKit

// MARK: - 自定义tabbar
class TabBarViewController: UITabBarController {
    
    lazy var tabbar = CustomTabBarView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
        addSubViewControllers()
        tabbar.toggleTabBar(index: 0)
    }
}

extension TabBarViewController {
    func hideTabbar() {
        CustonAnimation.animateHideView(view: tabbar, direction: .bottom, reverseDirection: .top, offset: 100)
    }
    
    func showTabbar() {
        CustonAnimation.animateShowView(view: tabbar, direction: .bottom, offset: 100)
    }
}

// MARK: - 界面初始化
extension TabBarViewController {
    func setupUI() {
        tabBar.isHidden = true
        
        tabbar.delegate = self
        view.addSubview(tabbar)
        tabbar.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(CustomTabBarView.tabbarHeight)
        }
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
