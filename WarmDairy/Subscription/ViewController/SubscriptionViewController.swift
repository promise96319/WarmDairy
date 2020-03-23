//
//  SubscriptionViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/23.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    lazy var backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension SubscriptionViewController {
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

extension SubscriptionViewController {
    func setupUI() {
        view.backgroundColor = .randomColor
        
    }
    
    func setupBg() {
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(8)
                $0.left.equalToSuperview().offset(8)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
    }
}
