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
        viewControllers.append(navigationController(rootViewController: CategoryViewController()))
        viewControllers.append(navigationController(rootViewController: MeViewController()))
        self.viewControllers = viewControllers
    }
    
    func navigationController(rootViewController: UIViewController) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.setNavigationBarHidden(true, animated: false)
        navigationVC.navigationBar.isTranslucent = false
        return navigationVC
    }
}
