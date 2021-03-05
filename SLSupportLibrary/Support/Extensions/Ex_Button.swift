//
//  Ex_Button.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

public extension SLEx where Base: UIButton {
    
    @discardableResult
    func title(_ title: String?, for state: UIControl.State = .normal) -> SLEx {
        base.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> SLEx {
        base.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> SLEx {
        base.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func background(_ image: UIImage?, for state: UIControl.State = .normal) -> SLEx {
        base.setBackgroundImage(image, for: state)
        return self
    }
    
    /// 创建带图片的按钮
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - image: 图片
    ///   - state: 状态
    ///   - space: 图片与文字间距
    ///   - position: 图片的位置
    @discardableResult
    func imagePosition(title: String?, image: UIImage?, state: UIControl.State = .normal, space: CGFloat = 10, position: ImagePosition = .left) -> SLEx {
        base.imageView?.contentMode = .center
        base.setImage(image, for: state)
        base.titleLabel?.contentMode = .center
        base.setTitle(title, for: state)
        imageSpace(title: title ?? "", space: space, position: position)
        return self
    }
    
    /// 修改图片位置
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - space: 间距
    ///   - position: 图片的位置
    @discardableResult
    func imageSpace(title: String, space: CGFloat, position: ImagePosition) -> SLEx {
        guard let imageSize = base.imageView?.frame.size,
              let titleFont = base.titleLabel?.font else { return  self}
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
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
        
        base.titleEdgeInsets = titleInsets
        base.imageEdgeInsets = imageInsets
        return self
    }
}

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
