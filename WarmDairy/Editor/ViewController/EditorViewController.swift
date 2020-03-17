//
//  EditorViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import Photos

class EditorViewController: UIViewController {
    
    lazy var editorView = SQTextEditorView()
    lazy var toolbar = ToolbarView()
    
    var picker: UIImagePickerController?
    
    lazy var bgImageView = UIImageView()
    lazy var bgMask = UIView()
    lazy var backButton = UIButton()
    lazy var saveButton = UIButton()
    lazy var dateButton = UIButton()
    lazy var lineView = UIView()
    
    lazy var titleField = UITextField()
    lazy var actionBar = UIView()
    enum ActionBarOptions: String {
        case weather = "weather"
        case mood = "mood"
        case location = "location"
        case love = "love"
        static let all: [ActionBarOptions] = [.weather, .mood, .location, .love]
    }
    lazy var actoinButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                DairyAPI.getDairy { (data) in
        //                    print("测试 ===> data的值为: \(data)")
        //                }
        //        DairyImageAPI.getImage {(data) in
        //            print("测试 ===> data的值为: \(data)")
        //        }
        setupUI()
    }
    
    deinit {
        
    }
}

// MARK: - 相册上传图片代理
extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 上传图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        var imageData = pickedImage.pngData()
        // 控制在2M以内
        var rate = imageData!.count / 2 * 1024 * 1024
        rate = rate <= 1 ? 1 : rate
        imageData = pickedImage.jpegData(compressionQuality: CGFloat(rate))
        if let path = DairyImageAPI.saveImageToTmp(image: UIImage(data: imageData!)!) {
            editorView.insertImage(url: path)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditorViewController {
    func insertImage() {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker = UIImagePickerController()
                picker?.delegate = self
                picker?.sourceType = .photoLibrary
                present(picker!, animated: true, completion: nil)
            } else {
                //                MessageManager.share.showMessage(theme: .warning, body: "Sorry, currently the device cannot access the album.")
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                guard let strongSelf = self else { return }
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        DispatchQueue.main.async {
                            strongSelf.picker = UIImagePickerController()
                            strongSelf.picker?.delegate = self
                            strongSelf.picker?.sourceType = .photoLibrary
                            strongSelf.present(strongSelf.picker!, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            //                            MessageManager.share.showMessage(theme: .warning, body: "Sorry, currently the device cannot access the album.")
                        }
                    }
                }
            }
        case .denied:
            break
        //            MessageManager.share.showMessage(theme: .warning, title: "Pemisseion denied", body: "Please authorize in the 'Settings'.")
        case .restricted:
            break
        //            MessageManager.share.showMessage(theme: .warning, title: "Pemisseion denied", body: "Please authorize in the 'Settings'.")
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - 事件处理
extension EditorViewController {
    
    /// 上传HTML前先保存图片，将URL替换成图片唯一的名称
    /// - Parameter html: html 字符串
    /// - Return html 字符串
    func beforeUploadHTML(html: String) -> String {
        //        Optional("<div><img src=\"/private/var/mobile/Containers/Data/Application/C63B2ADA-F9FB-4235-BB34-054F179A8CB6/tmp/editor/images/silence_158427570975781\"><br></div>")
        let pattern = "src=\\\"\(FileManager.tmpPath + DairyImageAPI.imagePath)/silence_[0-9]{15}\\\""
        print("测试 ===> pattern的值为: \(pattern)")
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex.matches(in: html, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, html.count))
        
        var newHTML = html
        for checkingRes in res {
            let res = (html as NSString).substring(with: checkingRes.range)
            // src="/private/var/mobile/Containers/Data/Application/219416EE-2291-4A1C-8AEC-EA4F081D075F/tmp/editor/images/silence_158427716981744"
            print("测试 ===> result的值为: \(res)")
            var path = res.replacingOccurrences(of: "src=\"", with: "")
            path = path.replacingOccurrences(of: "\"", with: "")
            print("测试 ===> path的值为: \(path)")
            let imageModel = DairyImageModel()
            imageModel.image = CreamAsset.create(object: imageModel, propName: DairyImageModel.key, url: URL(fileURLWithPath: path))
            DairyImageAPI.saveImage(path: path) { (fileName) in
                if let fileName = fileName {
                    newHTML = newHTML.replacingOccurrences(of: path, with: fileName)
                }
            }
        }
        
        print("测试 ===> html的值为: \(newHTML)")
        return newHTML
    }
    
    @objc func saveDairy() {
        
        editorView.getHTML { (html) in
            print("测试 ===> edi的值为: \(html)")
            if let html = html {
                let newHTML = self.beforeUploadHTML(html: html)
                let dairy = DairyModel()
                dairy.content = newHTML
                DairyAPI.addDairy(dairy: dairy) { (isAdded) in
                    if (isAdded) {
                        print("测试 ====> 成功")
                    }
                }
            } else {
                print("测试 ===>的值为: \("保存失败")")
            }
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

extension EditorViewController: SQTextEditorDelegate {
    func editorDidLoad(_ editor: SQTextEditorView) {
        print("editorDidLoad")
    }
    
    func editor(_ editor: SQTextEditorView, selectedTextAttributeDidChange attribute: SQTextAttribute) {
        print("测试 ===> change的值为: \(222)")
        toolbar.toolbarCollectionView.reloadData()
    }
    
    func editor(_ editor: SQTextEditorView, contentHeightDidChange height: Int) {
        print("contentHeightDidChange = \(height)")
    }
}

extension EditorViewController {
    func setupUI() {
        setupBg()
        setupEditorHeader()
        setupEditor()
    }
    
    func setupEditorHeader() {
        _ = actionBar.then {
                   view.addSubview($0)
                   $0.snp.makeConstraints {
                       $0.left.equalToSuperview().offset(24)
                       $0.right.equalToSuperview().offset(-24)
                       $0.top.equalTo(lineView.snp.bottom)
                       $0.height.equalTo(44)
                   }
               }
               
               for (index, item) in ActionBarOptions.all.enumerated() {
                   _ = UIButton().then {
                       actoinButtons.append($0)
                       $0.setImage(UIImage(named: "icon_editor_\(item.rawValue)"), for: .normal)
                       actionBar.addSubview($0)
                       $0.snp.makeConstraints {
                           $0.left.equalToSuperview().offset((index * 44))
                           $0.centerY.equalToSuperview()
                           $0.width.height.equalTo(44)
                       }
                   }
               }
        
        _ = titleField.then {
            $0.text = ""
            $0.placeholder = "标题"
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            $0.textColor = UIColor(hexString: "303133")
            $0.contentVerticalAlignment = .center
            $0.returnKeyType = .done
//            $0.delegate = self
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(actionBar.snp.bottom)
                $0.left.equalToSuperview().offset(24)
                $0.right.equalToSuperview().offset(-24)
            }
        }
    }
    
    func setupBg() {
        _ = bgImageView.then {
            $0.image = R.image.image_editor_bg()
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = bgMask.then {
            $0.backgroundColor = UIColor(hexString: "F6E6CD", alpha: 0.8)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
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
        
        _ = saveButton.then {
            $0.setTitle("保存", for: .normal)
            $0.setTitleColor(UIColor(hexString: "409EFF"), for: .normal)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(backButton)
                $0.right.equalToSuperview().offset(-24)
            }
            $0.addTarget(self, action: #selector(saveDairy), for: .touchUpInside)
        }
        
        _ = dateButton.then {
            $0.setTitle("2020年3月2日 星期天", for: .normal)
            $0.setTitleColor(UIColor(hexString: "303133"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(saveButton)
            }
        }
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(hexString: "303133", alpha: 0.5)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(1)
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(saveButton.snp.bottom).offset(8)
            }
        }
    }
    
    func setupEditor() {
        toolbar.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: ToolbarFrameModel.height)
        toolbar.editor = self.editorView
        toolbar.delegate = self
        
        _ = editorView.then {
            $0.inputAccessoryView = toolbar
            $0.backgroundColor = .clear
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.snp.makeConstraints {
                $0.top.equalTo(titleField.snp.bottom).offset(6)
                $0.left.right.bottom.equalToSuperview()
            }
        }
    }
}
