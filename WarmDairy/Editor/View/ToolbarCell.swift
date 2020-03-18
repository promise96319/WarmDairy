//
//  ToolbarCell.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/12.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

protocol ToolbarActionHandleDelegate {
    func cellClick(tool: ToolOptions) -> Void
}

class ToolbarCell: UICollectionViewCell {
    
    var delegate: ToolbarActionHandleDelegate?
    
    var tool: ToolOptions = .none
    
    let normalColor = UIColor(hexString: "303133")
    let toolTinyColor = UIColor(hexString: "409EFF")
    
    static let identifier = "ToolbarCell_ID"
    
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse()
    }
    
    func initData(tool: ToolOptions, attribute: SQTextAttribute) {
        self.tool = tool
        
        var isActive = false
        
        switch tool {
        case .bold:
            isActive = attribute.format.hasBold
            break
        case .italic:
            isActive = attribute.format.hasItalic
            break;
        case .underline:
            isActive = attribute.format.hasUnderline
            break
            
        case .align_left:
            isActive = attribute.align == .left
        case .align_center:
            isActive = attribute.align == .center
        case .align_right:
            isActive = attribute.align == .right
        default:
            break
        }
        
        imageView.image = UIImage(named: "icon_editor_\(self.tool.self)")?.withRenderingMode(.alwaysTemplate)
        
        if isActive {
            imageView.tintColor = toolTinyColor
        } else {
            imageView.tintColor = normalColor
        }
        
        if tool == .fontcolor {
            imageView.tintColor = attribute.textInfo.color
        }
    }
}

extension ToolbarCell {
    @objc func btnClick() {
        delegate?.cellClick(tool: self.tool)
    }
}

extension ToolbarCell {
    func setupUI() {
        
        _ = imageView.then {
            $0.isUserInteractionEnabled = true
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnClick))
            $0.addGestureRecognizer(tapGesture)
        }
    }
}
