//
//  SLUIButtonExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

/// button中图片的位置枚举
///
/// - left: 图片在左
/// - right: 图片在右
/// - top: 图片在上
/// - bottom: 图片在下
public enum ImagePosition {
    case left
    case right
    case top
    case bottom
}

/// 设置button中图片的位置
public extension UIButton {
    
    /// 创建带图片的按钮
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - image: 图片
    ///   - state: 状态
    ///   - space: 图片与文字间距
    ///   - position: 图片的位置
    func sl_setPosition(title: String?, image: UIImage?, state: UIControlState = .normal, space: CGFloat = 10, position: ImagePosition = .left) {
        
        imageView?.contentMode = .center
        setImage(image, for: state)
        titleLabel?.contentMode = .center
        setTitle(title, for: state)
        
        setEdgeInsets(title: title ?? "", space: space, position: position)
    }
    
    /// 修改图片位置
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - space: 间距
    ///   - position: 图片的位置
    private func setEdgeInsets(title: String, space: CGFloat, position: ImagePosition) {
        
        guard let imageSize = imageView?.frame.size,
            let titleFont = titleLabel?.font else { return }
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch position {
            
        case .bottom:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + space),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .top:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + space),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + space))
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -space)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }
}

public extension UIButton {
    /// 设置文字和文字颜色
    func sl_setTitleWithTitleColor(title: String, color: UIColor, state: UIControlState = .normal) {
        setTitle(title, for: state)
        setTitleColor(color, for: state)
    }
}
