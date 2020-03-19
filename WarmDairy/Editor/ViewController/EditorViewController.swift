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
import SwiftDate

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

    lazy var weatherButton = UIButton()
    lazy var moodButton = UIButton()
    lazy var loveButton = UIButton()
    
    lazy var weatherPicker = WeatherPicker()
    lazy var moodPicker = MoodPicker()
    lazy var datePicker = DatePicker()
    lazy var popMaskView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func initData(dairy: DairyModel) {
        myDairy = dairy
        chooseDate(date: dairy.createdAt)
        chooseMood(mood: dairy.mood)
        chooseWeather(weather: dairy.weather)
        setLoveImage()
        titleField.text = dairy.title
    }
    
    func initBg(image: String) {
        bgImageView.kf.setImage(with: URL(string: image))
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
        let day = date.toFormat("yyyy年MM月dd日")
        let week = date.weekdayName(.default, locale: Locales.chineseSimplified)
        dateButton.setTitle("\(day) \(week)", for: .normal)
        hideDatePicker()
    }
    
    func hideDatePicker() {
        UIView.animate(withDuration: 0.5) {
            self.datePicker.alpha = 0
            self.popMaskView.alpha = 0
        }
    }
    
    @objc func showDatePicker() {
        // TODO：如果是更新日记，暂且不允许改date
        if myDairy.images != "" { return }
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
        moodButton.setImage(UIImage(named: "icon_mood_\(mood)"), for: .normal)
        moodButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        hideMoodPicker()
    }
    
    @objc func showMoodPicker() {
        showMask()
        let animation = AnimationType.from(direction: .top, offset: 200.0)
        moodPicker.animate(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .transitionCurlUp, completion: nil)
    }
    
    func chooseWeather(weather: String) {
        myDairy.weather = weather
        weatherButton.setImage(UIImage.init(named: "icon_weather_\(weather)"), for: .normal)
        weatherButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        hideWeatherPicker()
    }
    
    @objc func showWeatherPicker() {
        showMask()
        let animation = AnimationType.from(direction: .top, offset: 200.0)
        weatherPicker.animate(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .transitionCurlUp, completion: nil)
    }
    
    /// 切换是否收藏该日记
    /// - Parameter isToggle: 默认为true，需要切换。为false的时候无需切换
    @objc func toggleLove() {
        myDairy.isLoved = !myDairy.isLoved
        setLoveImage()
    }
    
    func setLoveImage() {
        if myDairy.isLoved {
            loveButton.setImage(R.image.icon_editor_love_selected(), for: .normal)
        } else {
            loveButton.setImage(R.image.icon_editor_love(), for: .normal)
        }
    }
    
    func hideWeatherPicker() {
        UIView.animate(withDuration: 0.5) {
            self.weatherPicker.alpha = 0
            self.popMaskView.alpha = 0
        }
    }
    
    /// 上传HTML前先保存图片，将URL替换成图片唯一的名称
    /// - Parameter html: html 字符串
    /// - Return html 字符串
    func beforeUploadHTML(html: String, imagesStr: String) -> (String, String) {
        //        Optional("<div><img src=\"/private/var/mobile/Containers/Data/Application/C63B2ADA-F9FB-4235-BB34-054F179A8CB6/tmp/editor/images/silence_158427570975781\"><br></div>")
        let pattern = "src=\\\"\(FileManager.tmpPath + DairyImageAPI.imagePath)/\(DairyImageAPI.prefix)[0-9]{15}\\\""
        print("测试 ===> pattern的值为: \(pattern)")
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex.matches(in: html, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, html.count))
        
        /// 新的HTML
        var newHTML = html
        /// images id 数组：如果是更新，包含 已有id 和新增id
        var oldIds = [String]()
        var newIds = [String]()
        /// 已有的图片id
        var imageIds = [Substring]()
        
        for checkingRes in res {
            let res = (html as NSString).substring(with: checkingRes.range)
            // src="/private/var/mobile/Containers/Data/Application/219416EE-2291-4A1C-8AEC-EA4F081D075F/tmp/editor/images/silence_158427716981744"
            print("测试 ===> result的值为: \(res)")
            var path = res.replacingOccurrences(of: "src=\"", with: "")
            path = path.replacingOccurrences(of: "\"", with: "")
            print("测试 ===> path的值为: \(path)")
            
            ///  如果更新，需要将imgid进行对比
            if imagesStr != "" {
                imageIds = imagesStr.split(separator: ",")
                let idPattern = "[0-9]{15}"
                let idRegex = try! NSRegularExpression(pattern: idPattern, options: NSRegularExpression.Options.caseInsensitive)
                let idRes = idRegex.matches(in: path, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, path.count))
                if idRes.count > 0 {
                    /// html 中的图片id
                    let id = (path as NSString).substring(with: idRes[0].range)
                    if imageIds.contains(Substring(id)) {
                        // 说明已存在图片
                        let filename = "\(DairyImageAPI.prefix)\(id)"
                        newHTML = newHTML.replacingOccurrences(of: path, with: filename)
                        oldIds.append(id)
                    } else {
                        // 说明没有图片，保存图片
                        DairyImageAPI.saveImage(path: path) { (id) in
                            guard let id = id else { return }
                            let filename = "\(DairyImageAPI.prefix)\(id)"
                            newHTML = newHTML.replacingOccurrences(of: path, with: filename)
                            newIds.append("\(id)")
                        }
                    }
                } else {
                    /// 如果结果不存在，说明tmp 文件有问题
                    print("测试 ====> image tmp 文件路径有问题")
                }
            } else {
                // 说明是新增，直接将path替换
                DairyImageAPI.saveImage(path: path) { (id) in
                    guard let id = id else { return }
                    let filename = "\(DairyImageAPI.prefix)\(id)"
                    newHTML = newHTML.replacingOccurrences(of: path, with: filename)
                    newIds.append("\(id)")
                }
            }
            
            /// html 替换完毕，将没用的image 删除
            for imageId in imageIds {
                if !oldIds.contains(String(imageId)) {
                    if let id = Int(String(imageId)) {
                        DairyImageAPI.deleteImage(id: id)
                    }
                }
            }
            
        }
        
        print("测试 ===> html的值为: \(newHTML)")
        return (newHTML, (oldIds + newIds).joined(separator: ","))
    }
    
    /// 保存日记
    /// 判断日记images是否为空，
    ///      - 如果为空，不管是更新还是新增均无影响
    ///      - 如果不为空，说明一定是新增(只有新增过才会有images)
    /// 获取 html
    ///   - 如果是新增，替换HTML中的img链接，保存image，返回id存入到images中
    ///   - 如果是更新，找出HTML中的img（通过 prefix + id 形式），与images里的id对照
    ///         - img 中不包含images的，则删除这些images
    ///           - images中不包含img的，新增img
    /// 最终返回HTML
    /// 保存日记（查询判断是新增还是更新）
    @objc func saveDairy() {
        myDairy.title = titleField.text!
        editorView.getHTML { (html) in
            if let html = html {
                let res = self.beforeUploadHTML(html: html, imagesStr: self.myDairy.images)
                self.myDairy.content = res.0
                self.myDairy.images = res.1
                
                DairyAPI.addDairy(dairy: self.myDairy) { (isAdded) in
                    if (isAdded) {
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
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(lineView.snp.bottom)
                $0.height.equalTo(44)
            }
        }
        
        loveButton.tag = 0
        loveButton.addTarget(self, action: #selector(toggleLove), for: .touchUpInside)
        moodButton.tag = 1
        moodButton.addTarget(self, action: #selector(showMoodPicker), for: .touchUpInside)
        weatherButton.tag = 2
        weatherButton.addTarget(self, action: #selector(showWeatherPicker), for: .touchUpInside)
        [loveButton, moodButton, weatherButton].forEach {            $0.imageView?.contentMode = .scaleAspectFill
            actionBar.addSubview($0)
            let index = $0.tag
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset((-index * 44))
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(44)
            }
        }
        
        if myDairy.weather == "" {
            weatherButton.setImage(UIImage(named: "icon_editor_weather"), for: .normal)
            weatherButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        if myDairy.mood == "" {
            moodButton.setImage(UIImage(named: "icon_editor_mood"), for: .normal)
            moodButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        setLoveImage()
        
        _ = titleField.then {
            $0.text = myDairy.title
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

// MARK: - 插入图片
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
        print("text info changed")
        toolbar.toolbarCollectionView.reloadData()
    }
    
    func editor(_ editor: SQTextEditorView, contentHeightDidChange height: Int) {
        print("contentHeightDidChange = \(height)")
    }
}
