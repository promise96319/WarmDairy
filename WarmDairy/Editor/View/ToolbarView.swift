//
//  ToolbarView.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import ViewAnimator
import SwiftyUserDefaults

class ToolbarView: UIView {

    lazy var tools = ToolOptions.all
    
    weak var delegate: EditorViewController?
    
    var toolbarCollectionView: UICollectionView!
    lazy var keyboardButton = UIButton()
    lazy var fontSizePicker = UIView()
    lazy var fontSizeSlider = UISlider()
    lazy var fontSizeLabel = UILabel()
    
    lazy var fontColorPicker = UIView()
    var fontColors = [
        "303133", "61d4b3", "f57b51", "7a4d1d", "9dc6a7", "be79df", "98d6ea",
        "ff4777", "1685a9", "1eb2a6", "cca413", "a6b1e1", "f47983", "216353",
        "ffe3ed", "142850", "ff4617", "622a1d", "70f3ff", "00e079", "boa4e3",
        "ffc7c7", "feb377", "eab0d9", "177cb0", "789262", "ff8936", "808080",
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func initData(tools: [ToolOptions]) {
        self.tools = tools
    }
    
    deinit {
        CLog("toolbar注销")
    }
}

// MARK: - 事件处理
extension ToolbarView {
    @objc func chooseFontColor(sender: UITapGestureRecognizer) {
        let vtag = sender.view?.tag
        guard let tag = vtag else { return }

        if !Defaults[.isVIP] && tag >= VIPModel.fontColorCount {
            let vc = SubscriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            delegate?.present(vc, animated: true, completion: nil)
            return
        }
        AnalysisTool.shared.logEvent(event: "editor_toolbar_choosefontcolor_\(tag)")
        delegate?.editorView?.setText(color: UIColor(hexString: fontColors[tag])!)
        hideFontColorPicker()
    }
    
    func showFontColorPicker() {
        AnalysisTool.shared.logEvent(event: "editor_toolbar_showfontcolorpicker")
        fontColorPicker.alpha = 1
        let animation = AnimationType.from(direction: .right, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
        UIView.animate(views: [fontColorPicker], animations: [animation], reversed: false, initialAlpha: 1, finalAlpha: 1, delay: 0, duration: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut)
    }
    
    @objc func hideFontColorPicker() {
        let animation = AnimationType.from(direction: .right, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
        UIView.animate(views: [fontColorPicker], animations: [animation], reversed: true, initialAlpha: 1, finalAlpha: 1, delay: 0, duration: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut)  { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.fontColorPicker.alpha = 0
                    let animation2 = AnimationType.from(direction: .left, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
            UIView.animate(views: [weakSelf.fontColorPicker], animations: [animation2], reversed: true, initialAlpha: 0, finalAlpha: 0, duration: 0)
            }
    }
    
    @objc func fontSizeChanged(sender: UISlider) {
        let size = Int(sender.value)
        fontSizeLabel.text = "\(size)pt"
        delegate?.editorView?.setText(size: size)
    }
    
    func showFontSizePicker() {
        AnalysisTool.shared.logEvent(event: "editor_toolbar_showfontsizepicker")
        fontSizePicker.alpha = 1
        let animation = AnimationType.from(direction: .right, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
        UIView.animate(views: [fontSizePicker], animations: [animation], reversed: false, initialAlpha: 1, finalAlpha: 1, delay: 0, duration: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut)
    }
    
    @objc func hideFontSizePicker() {
        let animation = AnimationType.from(direction: .right, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
        UIView.animate(views: [fontSizePicker], animations: [animation], reversed: true, initialAlpha: 1, finalAlpha: 1, delay: 0, duration: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut)  { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.fontSizePicker.alpha = 0
                    let animation2 = AnimationType.from(direction: .left, offset: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth)
            UIView.animate(views: [weakSelf.fontSizePicker], animations: [animation2], reversed: true, initialAlpha: 0, finalAlpha: 0, duration: 0)
            }
        
    }
    
    func insertImage() {
        delegate?.insertImage()
    }
    
    @objc func collapseKeyboard() {
        delegate?.editorView?.collpaseKeyboard()
    }
}

extension ToolbarView: ToolbarActionHandleDelegate {
    func cellClick(tool: ToolOptions) {
        switch tool {
        case .image:
            insertImage()
            break
        case .fontsize:
            showFontSizePicker()
            break
        case .fontcolor:
            showFontColorPicker()
            break
        case .bold:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_bold_clicked")
            delegate?.editorView?.bold()
            break
        case .italic:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_italic_clicked")
            delegate?.editorView?.italic()
            break
        case .underline:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_underline_clicked")
            delegate?.editorView?.underline()
            break
        case .align_left:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_align_left_clicked")
            if delegate?.editorView?.selectedTextAttribute.align == .left {
                break
            }
            delegate?.editorView?.setTextAlignment(alignment: "left") {_ in}
            toolbarCollectionView.reloadData()
            break
        case .align_center:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_align_center_clicked")
            if delegate?.editorView?.selectedTextAttribute.align == .center {
                break
            }
            delegate?.editorView?.setTextAlignment(alignment: "center") {_ in}
            toolbarCollectionView.reloadData()
            break
        case .align_right:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_align_right_clicked")
            if delegate?.editorView?.selectedTextAttribute.align == .right {
                break
            }
            delegate?.editorView?.setTextAlignment(alignment: "right") {_ in}
            toolbarCollectionView.reloadData()
            break
        case .undo:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_undo_clicked")
            delegate?.editorView?.undo { _ in }
        case .redo:
            AnalysisTool.shared.logEvent(event: "editor_toolbar_redo_clicked")
            delegate?.editorView?.redo { _ in }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ToolbarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
}

// MARK: - UICollectionViewDelegate
extension ToolbarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolbarCell.identifier, for: indexPath) as! ToolbarCell
        cell.initData(tool: tools[indexPath.row], attribute: (delegate?.editorView?.selectedTextAttribute)!)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ToolbarView {
    func setupUI() {
        backgroundColor = UIColor(hexString: "#eeeeee")
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: ToolbarFrameModel.cellWidth, height: ToolbarFrameModel.cellHeight)
            $0.minimumLineSpacing = ToolbarFrameModel.verticleSpacing
            $0.minimumInteritemSpacing = 0
            
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
        
        toolbarCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            addSubview($0)
            $0.register(ToolbarCell.self, forCellWithReuseIdentifier: ToolbarCell.identifier)
            $0.snp.makeConstraints {
                $0.left.bottom.equalToSuperview()
                $0.height.equalTo(ToolbarFrameModel.cellHeight)
                $0.right.equalToSuperview().offset(-ToolbarFrameModel.cellWidth)
            }
        }
        
        setupFontSizePicker()
        setupFontColorPicker()
        
        _ = keyboardButton.then {
            $0.setImage(R.image.icon_editor_keyboard(), for: .normal)
            $0.backgroundColor = UIColor(hexString: "#eeeeee")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
                $0.width.height.equalTo(ToolbarFrameModel.cellWidth)
            }
            $0.addTarget(self, action: #selector(collapseKeyboard), for: .touchUpInside)
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "c0c4cc")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(keyboardButton)
                
                $0.left.equalTo(keyboardButton)
                $0.height.equalTo(ToolbarFrameModel.cellHeight * 0.5)
                $0.width.equalTo(1)
            }
        }
    }
    
    func setupFontSizePicker() {
        _ = fontSizePicker.then {
            $0.alpha = 0
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = UIColor(hexString: "eeeeee")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(44)
            }
        }
        
        let backButton = UIButton().then {
            $0.setTitle("返回", for: .normal)
            $0.setTitleColor(UIColor(hexString: "303133"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.titleLabel?.textAlignment = .center
            fontSizePicker.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.bottom.equalToSuperview()
                $0.width.height.equalTo(ToolbarFrameModel.cellWidth)
            }
            $0.addTarget(self, action: #selector(hideFontSizePicker), for: .touchUpInside)
        }
        
        _ = fontSizeSlider.then {
            $0.minimumValue = 12
            $0.maximumValue = 40
            $0.value = 16
            $0.isUserInteractionEnabled = true
            $0.isContinuous = true
            fontSizePicker.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(backButton.snp.right).offset(64)
                $0.right.equalToSuperview().offset(-ToolbarFrameModel.cellWidth - 12)
                $0.height.equalTo(44)
            }
            $0.addTarget(self, action: #selector(fontSizeChanged), for: .valueChanged)
        }
        
        _ = fontSizeLabel.then {
            $0.text = "16pt"
            fontSizePicker.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalTo(fontSizeSlider.snp.left).offset(-12)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    func setupFontColorPicker() {
        _ = fontColorPicker.then {
            $0.backgroundColor = UIColor(hexString: "eeeeee")
            $0.alpha = 0
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        let backButton = UIButton().then {
            $0.setTitle("返回", for: .normal)
            $0.setTitleColor(UIColor(hexString: "303133"), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.titleLabel?.textAlignment = .center
            fontColorPicker.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.bottom.equalToSuperview()
                $0.width.height.equalTo(ToolbarFrameModel.cellWidth)
            }
            $0.addTarget(self, action: #selector(hideFontColorPicker), for: .touchUpInside)
        }
        
        let scrollView = UIScrollView().then {
            $0.contentSize = CGSize(width: fontColors.count * 44, height: 44)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            fontColorPicker.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(backButton.snp.right)
                $0.right.equalToSuperview().offset(-44)
                $0.height.equalTo(44)
                $0.bottom.equalToSuperview()
            }
        }
        
        for (index, color) in fontColors.enumerated() {
            let v = UIView().then {
                $0.tag = index
                scrollView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(44)
                    $0.centerY.equalToSuperview()
                    $0.left.equalToSuperview().offset(index * 44)
                }
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseFontColor))
                $0.addGestureRecognizer(tapGesture)
            }
            _ = UIView().then {
                $0.layer.borderColor = UIColor(hexString: "eeeeee")?.cgColor
                $0.layer.borderWidth = 1
                $0.backgroundColor = UIColor(hexString: color)
                $0.layer.cornerRadius = 12
                $0.clipsToBounds = true
                v.addSubview($0)
                $0.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.height.equalTo(24)
                }
            }
            
            if !Defaults[.isVIP] && index >= VIPModel.fontColorCount {
                _ = UIImageView().then {
                    $0.image = UIImage(named: "icon_me_premium")?.withAlignmentRectInsets(UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6))
                    $0.contentMode = .scaleAspectFill
                    v.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.width.height.equalTo(24)
                        $0.center.equalToSuperview()
                    }
                }
            }
        }
    }
}
