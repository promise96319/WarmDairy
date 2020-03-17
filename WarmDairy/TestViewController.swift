//
//  TestViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/14.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import CloudKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(Changee), name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil)
        setupUI()
    }
}

extension TestViewController {
    @objc func Changee() {
        print("测试 ===> add的值为: \(22)")
        DairyAPI.getDairy { (data) in
            print("测试 ===> data的值为: \(data)")
            
            
        }
        
        let label = UILabel().then {
            $0.text = "测试重登家大家啊家假按揭啊假按揭啊"
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    @objc func add() {
        let dairy = DairyModel()
        dairy.content = "测试测试"
        DairyAPI.addDairy(dairy: dairy) { (isAdded) in
            if (isAdded) {
                print("测试 ====> 成功")
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemPink
        let btn = UIButton().then {
            $0.setTitle("添加", for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(100)
            }
            $0.addTarget(self, action: #selector(add), for: .touchUpInside)
        }
        
        
        let recordID = CKRecord.ID(recordName: "test")
        let record = CKRecord(recordType: "UserInfo", recordID: recordID)
        record["username"] = "silence"
        record["password"] = "mima"
        
        let myContainer = CKContainer(identifier: "iCloud.com.GuanghuiQin.WarmDairy")
        let database = myContainer.database(with: .private)
        
        database.save(record) { (record, error) in
            if let error = error {
                print("测试 ===> Baocun 失败的值为: \(error)")
            } else {
                print("测试 ===> 保存chenggong的值为: \(record)")
            }
        }
    }
}
