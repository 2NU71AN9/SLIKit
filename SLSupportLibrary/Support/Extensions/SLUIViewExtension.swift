//
//  SLUIViewExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

// MARK: - frame
public extension UIView {
    
    /// 获取frame的x
    var sl_x: CGFloat { return frame.origin.x }
    
    /// 获取frame的y
    var sl_y: CGFloat { return frame.origin.y }
    
    /// 获取frame的宽度
    var sl_width: CGFloat { return frame.size.width }
    
    /// 获取frame的高度
    var sl_height: CGFloat { return frame.size.height }
    
    /// 获取frame的maxX
    var sl_MaxX: CGFloat { return sl_x + sl_width }
    
    /// 获取frame的maxY
    var sl_MaxY: CGFloat { return sl_y + sl_height }
    
    /// 在屏幕上的位置,相对于屏幕,不是相对于SuperView
    var sl_frameOnScreen: CGRect {
        let window = UIApplication.shared.windows[0]
        let rect = self.convert(bounds, to: window)
        return rect
    }
    
    /// 设置frame的x
    ///
    /// - Parameter x: x
    func sl_x(x: CGFloat) { frame.origin.x = x }
    
    /// 设置frame的y
    ///
    /// - Parameter y: y
    func sl_y(y: CGFloat) { frame.origin.y = y }
    
    /// 设置frame的宽度
    ///
    /// - Parameter width: 宽
    func sl_width(width: CGFloat) { frame.size.width = width }
    
    /// 设置frame的高度
    ///
    /// - Parameter height: 高
    func sl_height(height: CGFloat) { frame.size.height = height }
}

// MARK: -
public extension UIView {
    
    /// 裁切圆角
    ///
    /// - Parameter radius: 弧度
    func sl_clip(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - opacity: 透明度
    ///   - offset: 偏移量
    func sl_setShadow(color: UIColor, opacity: Float, offset: CGSize = CGSize(width: 0, height: 0)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
    
    /// 设置边框
    ///
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    ///   - radius: 弧度
    func sl_setBorder(width: CGFloat, color: UIColor, radius: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        sl_clip(radius: radius)
    }
    
    /// 从xib加载view
    ///
    /// - Returns: view
    static func sl_loadNib() -> UIView? {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? UIView
    }
}

public extension UIView {
    //返回该view所在VC
    public func sl_viewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
