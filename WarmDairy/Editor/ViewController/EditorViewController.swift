//
//  EditorViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import Photos
import ViewAnimator

extension NSNotification.Name {
    /// 日记被添加了
    static let dairyDidAdded = Notification.Name("dairyDidAdded")
}

class EditorViewController: UIViewController {
    
    lazy var myDairy = DairyModel()
    
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
    lazy var actionButtons = [UIButton]()
    
    lazy var weatherPicker = WeatherPicker()
    lazy var moodPicker = MoodPicker()
    lazy var datePicker = DatePicker()
    lazy var popMaskView = UIView()
    
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
    
    func initData(dairy: DairyModel) {
        myDairy = dairy
    }
    
    deinit {
        
    }
}

// MARK: - 事件处理
extension EditorViewController {
    @objc func hideMask() {
        hideWeatherPicker()
        hideMoodPicker()
        hideDatePicker()
    }
    
    func showMask() {
        UIView.animate(withDuration: 0.3) {
            self.popMaskView.alpha = 1
        }
        titleField.resignFirstResponder()
        editorView.collpaseKeyboard()
    }
    
    func chooseDate(date: Date) {
        myDairy.createdAt = date
        let dateStr = "\(date.year)年\(date.month)月\(date.day)日 \(date.weekday.toWeek())"
        dateButton.setTitle(dateStr, for: .normal)
        hideDatePicker()
    }
    
    func hideDatePicker() {
        UIView.animate(withDuration: 0.5) {
            self.datePicker.alpha = 0
            self.popMaskView.alpha = 0
        }
    }
    
    @objc func showDatePicker() {
        showMask()
        let animation = AnimationType.from(direction: .top, offset: 200.0)
        datePicker.animate(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .transitionCurlUp, completion: nil)
    }
    
    func hideMoodPicker() {
        UIView.animate(withDuration: 0.5) {
            self.moodPicker.alpha = 0
            self.popMaskView.alpha = 0
        }
    }
    
    func chooseMood(mood: String) {
        myDairy.mood = mood
        actionButtons[1].setImage(UIImage(named: "icon_mood_\(mood)"), for: .normal)
        actionButtons[1].imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        hideMoodPicker()
    }
    
    @objc func showMoodPicker() {
        showMask()
        let animation = AnimationType.from(direction: .top, offset: 200.0)
        moodPicker.animate(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .transitionCurlUp, completion: nil)
    }
    
    func chooseWeather(weather: String) {
        myDairy.weather = weather
        actionButtons[0].setImage(UIImage.init(named: "icon_weather_\(weather)"), for: .normal)
        actionButtons[0].imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        hideWeatherPicker()
    }
    
    @objc func showWeatherPicker() {
        showMask()
        let animation = AnimationType.from(direction: .top, offset: 200.0)
        weatherPicker.animate(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .transitionCurlUp, completion: nil)
    }
    
    /// 切换是否收藏该日记
    /// - Parameter isToggle: 默认为true，需要切换。为false的时候无需切换
    func toggleLoveOrNot(isToggle: Bool = true) {
        if isToggle {
            myDairy.isLoved = !myDairy.isLoved
        }
        
        if myDairy.isLoved {
            actionButtons[3].setImage(R.image.icon_editor_love_selected(), for: .normal)
        } else {
            actionButtons[3].setImage(R.image.icon_editor_love(), for: .normal)
        }
    }
    
    func hideWeatherPicker() {
        UIView.animate(withDuration: 0.5) {
            self.weatherPicker.alpha = 0
            self.popMaskView.alpha = 0
        }
    }
    
    @objc func clickPicker(sender: UIButton) {
        switch sender.tag {
        case 0:
            showWeatherPicker()
        case 1:
            showMoodPicker()
        case 2:
            
            break
        case 3:
            toggleLoveOrNot()
            break
        default:
            break
        }
    }
    
    /// 上传HTML前先保存图片，将URL替换成图片唯一的名称
    /// - Parameter html: html 字符串
    /// - Return html 字符串
    func beforeUploadHTML(html: String) -> (String, String) {
        //        Optional("<div><img src=\"/private/var/mobile/Containers/Data/Application/C63B2ADA-F9FB-4235-BB34-054F179A8CB6/tmp/editor/images/silence_158427570975781\"><br></div>")
        let pattern = "src=\\\"\(FileManager.tmpPath + DairyImageAPI.imagePath)/\(DairyImageAPI.prefix)[0-9]{15}\\\""
        print("测试 ===> pattern的值为: \(pattern)")
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex.matches(in: html, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, html.count))
        
        var newHTML = html
        var ids = [String]()
        for checkingRes in res {
            let res = (html as NSString).substring(with: checkingRes.range)
            // src="/private/var/mobile/Containers/Data/Application/219416EE-2291-4A1C-8AEC-EA4F081D075F/tmp/editor/images/silence_158427716981744"
            print("测试 ===> result的值为: \(res)")
            var path = res.replacingOccurrences(of: "src=\"", with: "")
            path = path.replacingOccurrences(of: "\"", with: "")
            print("测试 ===> path的值为: \(path)")
            DairyImageAPI.saveImage(path: path) { (id) in
                guard let id = id else { return }
                let filename = "\(DairyImageAPI.prefix)\(id)"
                newHTML = newHTML.replacingOccurrences(of: path, with: filename)
                ids.append("\(id)")
            }
        }
        
        print("测试 ===> html的值为: \(newHTML)")
        /// todo 删除已有 没有用的image
        return (newHTML, ids.joined(separator: ","))
    }
    
    @objc func saveDairy() {
        myDairy.title = titleField.text!
        editorView.getHTML { (html) in
            if let html = html {
                let res = self.beforeUploadHTML(html: html)
                self.myDairy.content = res.0
                self.myDairy.images = res.1
                
                DairyAPI.addDairy(dairy: self.myDairy) { (isAdded) in
                    if (isAdded) {
                        NotificationCenter.default.post(name: .dairyDidAdded, object: nil)
                        self.dismiss(animated: true, completion: nil)
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

// MARK: - UI 界面
extension EditorViewController {
    func setupUI() {
        setupBg()
        setupEditorHeader()
        setupEditor()
        setupPickers()
    }
    
    func setupPickers() {
        _ = popMaskView.then {
            $0.alpha = 0
            $0.backgroundColor = UIColor(hexString: "000000", alpha: 0.5)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMask))
            $0.addGestureRecognizer(tapGesture)
        }
        
        _ = weatherPicker.then {
            $0.alpha = 0
            $0.delegate = self
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(WeatherFrameModel.totalWidth)
                $0.height.equalTo(WeatherFrameModel.totalHeight)
            }
        }
        
        _ = moodPicker.then {
            $0.alpha = 0
            $0.delegate = self
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(MoodFrameModel.totalWidth)
                $0.height.equalTo(MoodFrameModel.totalHeight)
            }
        }
        
        _ = datePicker.then {
            $0.alpha = 0
            $0.delegate = self
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(DeviceInfo.screenWidth - 48)
                $0.height.equalTo(320)
            }
        }
    }
    
    func setupEditorHeader() {
        _ = actionBar.then {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-24)
                $0.width.equalTo(ActionBarOptions.all.count * 44)
                $0.top.equalTo(lineView.snp.bottom)
                $0.height.equalTo(44)
            }
        }
        
        for (index, item) in ActionBarOptions.all.enumerated() {
            _ = UIButton().then {
                actionButtons.append($0)
                $0.setImage(UIImage(named: "icon_editor_\(item.rawValue)"), for: .normal)
                $0.imageView?.contentMode = .scaleAspectFill
                actionBar.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.equalToSuperview().offset((index * 44))
                    $0.centerY.equalToSuperview()
                    $0.width.height.equalTo(44)
                }
                $0.tag = index
                $0.addTarget(self, action: #selector(clickPicker), for: .touchUpInside)
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
            $0.delegate = self
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
            chooseDate(date: myDairy.createdAt)
            $0.setTitleColor(UIColor(hexString: "303133"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(saveButton)
            }
            $0.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
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

// MARK: - 标题输入 textfield 代理
extension EditorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 40
        let currentString = textField.text! as NSString
        let newString =
            currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //        editorView.becomeFirstResponder()
        return true
    }
}

// MARK: - 相册上传图片代理
extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 上传图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        var imageData = pickedImage.pngData()
        // 控制在2M以内
        var rate =  CGFloat(2 * 1024 * 1024) / CGFloat(imageData!.count)
        print("测试 ===> rate的值为: \(rate)")
        rate = rate >= 1 ? 1 : rate
        imageData = pickedImage.jpegData(compressionQuality: CGFloat(rate))
        
        print("测试 ===> imagedata的值为: \(imageData!.count / 1024 / 1024)")
        // 压缩系数
        var resizeRate: Int = 10
        // 头像限制大小 <= 100kb
        while imageData!.count > 2 * 1024 * 1024 && resizeRate > 1 {
            resizeRate -= 1
            imageData = pickedImage.jpegData(compressionQuality: CGFloat(resizeRate / 10))
        }
        
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

// MARK: - editor delegate
extension EditorViewController: SQTextEditorDelegate {
    func editorDidLoad(_ editor: SQTextEditorView) {
        print("editorDidLoad")
        editorView.insertHTML(myDairy.content)
    }
    
    func editor(_ editor: SQTextEditorView, selectedTextAttributeDidChange attribute: SQTextAttribute) {
        print("测试 ===> change的值为: \(222)")
        toolbar.toolbarCollectionView.reloadData()
    }
    
    func editor(_ editor: SQTextEditorView, contentHeightDidChange height: Int) {
        print("contentHeightDidChange = \(height)")
    }
}
