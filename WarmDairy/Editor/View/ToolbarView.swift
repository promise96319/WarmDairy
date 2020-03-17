//
//  ToolbarView.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class ToolbarView: UIView {
    lazy var tools = ToolOptions.all
    
    weak var delegate: EditorViewController?
    weak var editor: SQTextEditorView?
    
    var toolbarCollectionView: UICollectionView!
    lazy var keyboardButton = UIButton()
    
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
}

// MARK: - 事件处理
extension ToolbarView {
    func insertImage() {
        delegate?.insertImage()
    }
    
    @objc func collapseKeyboard() {
        editor?.collpaseKeyboard()
    }
}

extension ToolbarView: ToolbarActionHandleDelegate {
    func cellClick(tool: ToolOptions) {
        switch tool {
        case .image:
            insertImage()
            break
        case .font:
            break
        case .bold:
            editor?.bold()
        case .italic:
            editor?.italic()
        case .underline:
            editor?.underline()
        case .align_left:
            if editor?.selectedTextAttribute.align == .left {
                break
            }
            editor?.setTextAlignment(alignment: "left") {_ in}
            toolbarCollectionView.reloadData()
        case .align_center:
            if editor?.selectedTextAttribute.align == .center {
                break
            }
            editor?.setTextAlignment(alignment: "center") {_ in}
            toolbarCollectionView.reloadData()
        case .align_right:
            if editor?.selectedTextAttribute.align == .right {
                break
            }
            editor?.setTextAlignment(alignment: "right") {_ in}
            toolbarCollectionView.reloadData()
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
        cell.initData(tool: tools[indexPath.row], attribute: (editor?.selectedTextAttribute)!)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


extension ToolbarView {
    func setupUI() {
        backgroundColor = UIColor(hexString: "#eeeeee")
        
        _ = keyboardButton.then {
            $0.setImage(R.image.icon_editor_keyboard(), for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.width.height.equalTo(ToolbarFrameModel.cellWidth)
            }
            $0.addTarget(self, action: #selector(collapseKeyboard), for: .touchUpInside)
        }
        
        _ = UIView().then {
            $0.backgroundColor = UIColor(hexString: "c0c4cc")
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                
                $0.left.equalTo(keyboardButton)
                $0.height.equalTo(ToolbarFrameModel.cellHeight * 0.5)
                $0.width.equalTo(1)
            }
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: ToolbarFrameModel.cellWidth, height: ToolbarFrameModel.cellHeight)
            $0.minimumLineSpacing = ToolbarFrameModel.verticleSpacing
            $0.minimumInteritemSpacing = 0
            
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
        
        toolbarCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth - ToolbarFrameModel.cellWidth, height: ToolbarFrameModel.height), collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            addSubview($0)
            $0.register(ToolbarCell.self, forCellWithReuseIdentifier: ToolbarCell.identifier)
        }
        
    }
}
