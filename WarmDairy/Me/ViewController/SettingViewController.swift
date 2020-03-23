//
//  SettingViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/22.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import Photos

class SettingViewController: UIViewController {
    
    lazy var userInfo = UserInfo()
    
    lazy var hearerContainer = UIView()
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton()
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var userContainer = UIView()
    lazy var avatarCell = SettingCell()
    lazy var nameCell = SettingCell()
    lazy var discriptionCell = SettingCell()
    
    var picker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .userInfoDidChanged, object: nil)
        (navigationController?.tabBarController as? TabBarViewController)?.hideTabbar()
        setupUI()
        loadData()
    }
    
    @objc func loadData() {
        UserInfoAPI.getUser { (userInfo) in
            CLog("user的值为: \(userInfo)")
            self.userInfo = userInfo
            
            self.avatarCell.initData(leftText: "头像", avatar: userInfo.avatar) {
                self.chooseAvatar()
            }
            self.nameCell.initData(leftText: "昵称", rightText: userInfo.name) {
                self.rename()
            }
            self.discriptionCell.initData(leftText: "个性签名", rightText: userInfo.motto, isBorder: false) {
                self.changeDiscription()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userInfoDidChanged, object: nil)
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        var imageData = pickedImage.pngData()
        
        // 压缩系数
        var resizeRate: Int = 10
        // 头像限制大小 <= 100kb
        while imageData!.count > 400 * 1024 && resizeRate > 1 {
            resizeRate -= 1
            imageData = pickedImage.jpegData(compressionQuality: CGFloat(resizeRate / 10))
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        let avatar = CreamAsset.create(object: self.userInfo, propName: UserInfo.avatarKey, data: imageData!)
        UserInfoAPI.saveUserInfo(userInfo: ["avatar": avatar as Any])
    }
}

// MARK: - 事件处理
extension SettingViewController {
    @objc func goBack() {
        (navigationController?.tabBarController as? TabBarViewController)?.showTabbar()
        navigationController?.popViewController(animated: true)
    }
    
    func chooseAvatar() {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photosStatus {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker = UIImagePickerController()
                picker?.delegate = self
                picker?.sourceType = .photoLibrary
                present(picker!, animated: true, completion: nil)
            } else {
                CLog("图片不支持")
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                guard let strongSelf = self else { return }
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        strongSelf.picker = UIImagePickerController()
                        strongSelf.picker?.delegate = self
                        strongSelf.picker?.sourceType = .photoLibrary
                        strongSelf.present(strongSelf.picker!, animated: true, completion: nil)
                    } else {
                        CLog("不支持选取图片")
                    }
                }
            }
        default:
            let alert = UIAlertController(title: "温馨提示", message: "您还未开启相册权限，无法选择照片", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "前往设置", style: .default, handler: {
                ACTION in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                  CLog("开启设置")
                        })
                    } else {
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                        
                    }
                })
            })
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            CLog("用户拒绝了相册授权")
        }
    }
    
    func rename() {
        let alert = UIAlertController(title: "昵称", message: "", preferredStyle: .alert)
        
        alert.addTextField{(usernameText) ->Void in
            usernameText.placeholder = "昵称"
            usernameText.text = self.userInfo.name
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    UserInfoAPI.saveUserInfo(userInfo: ["name": text])
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeDiscription() {
        let alert = UIAlertController(title: "个性签名", message: "", preferredStyle: .alert)
        
        alert.addTextField{(usernameText) ->Void in
            usernameText.placeholder = "个性签名"
            usernameText.text = self.userInfo.motto
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "确定", style: .default, handler: {
            ACTION in
            let text = alert.textFields?.first?.text
            if let text = text {
                if text != "" {
                    UserInfoAPI.saveUserInfo(userInfo: ["motto": text])
                }
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController {
    func setupUI() {
        setupBg()
        setupUserInfo()
    }
    
    func setupUserInfo() {
        _ = userContainer.then {
            addBg(view: $0)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalToSuperview().offset(SettingCellModel.sectionSpacing)
                $0.height.equalTo(3 * SettingCellModel.cellHeight + 2 * SettingCellModel.spacing)
                $0.bottom.equalTo(contentView.snp.bottom).offset(-100)
            }
        }
        
        for (index, cell) in [avatarCell, nameCell, discriptionCell].enumerated() {
            _ = cell.then {
                userContainer.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(SettingCellModel.cellHeight)
                    $0.top.equalToSuperview().offset(SettingCellModel.spacing + CGFloat(index) * SettingCellModel.cellHeight)
                }
            }
        }
    }
    
    func setupBg() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = hearerContainer.then {
            $0.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.backgroundColor = UIColor(hexString: "F1F6FA")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(topLayoutGuide.snp.bottom).offset(54)
            }
        }
        
        _ = titleLabel.then {
            $0.text = "设置"
            $0.textColor = UIColor(hexString: "303133")
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            }
        }
        
        _ = backButton.then {
            $0.setImage(R.image.icon_editor_back(), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.left.equalToSuperview().offset(14)
                $0.width.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(hearerContainer.snp.bottom)
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
    }
    
    func addBg(view: UIView) {
        view.backgroundColor = UIColor(hexString: "FEFFFF", alpha: 0.8)
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

