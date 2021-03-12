//
//  Ex_UIView.swift
//  SLIKit
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension SLEx where Base: UIView {
    
    @discardableResult
    func frame(_ frame: CGRect) -> SLEx {
        base.frame = frame
        return self
    }
    
    @discardableResult
    func add(subView view: UIView?) -> SLEx {
        guard let view = view else { return self }
        switch base {
        case let v as UIStackView:
            v.addArrangedSubview(view)
        default:
            base.addSubview(view)
        }
        return self
    }
    
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> SLEx {
        base.backgroundColor = color
        return self
    }
    
    /// 在屏幕上的位置,相对于屏幕,不是相对于SuperView
    var frameOnScreen: CGRect {
        let window = UIApplication.shared.keyWindow
        let rect = base.convert(base.bounds, to: window)
        return rect
    }
    
    /// 从xib加载view
    @discardableResult
    static func loadNib() -> SLEx? {
        let moduleName = Base.description().components(separatedBy: ".").first ?? ""
        let bundle = Bundle.sl.moduleBundle(Base.self, moduleName) ?? Bundle.main
        return (bundle.loadNibNamed("\(Base.self)", owner: nil, options: nil)?.first as? Base)?.sl
    }
    
    /// 返回该view所在VC
    var superVC: UIViewController? {
        for view in sequence(first: base.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    /// 返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: base.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
    
    @discardableResult
    func removeAllSubviews() -> SLEx {
        while base.subviews.count > 0 {
            base.subviews.last?.removeFromSuperview()
        }
        return self
    }
    
    @discardableResult
    func addTarget(_ target: Any?, action: Selector?) -> SLEx {
        base.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        base.addGestureRecognizer(tap)
        return self
    }
    
    var tap: ControlEvent<UITapGestureRecognizer> {
        base.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        base.addGestureRecognizer(tap)
        return tap.rx.event
    }
    
    /// 设置阴影
    @discardableResult
    func makeShadow(_ cornerRadius: CGFloat = 5,
                    color: UIColor? = UIColor(red: 0, green: 0, blue: 0, alpha: 0.21),
                    offset: CGSize = CGSize.zero,
                    opacity: Float = 1) -> SLEx {
        base.layer.cornerRadius = cornerRadius
        base.layer.shadowColor = color?.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowOpacity = opacity
        base.layer.shadowRadius = cornerRadius
        return self
    }
    
    /// 设置颜色渐变
    @discardableResult
    func makeGradient(_ colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) -> SLEx {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = colors
        bgLayer.locations = locations
        bgLayer.frame = base.bounds
        bgLayer.startPoint = startPoint
        bgLayer.endPoint = endPoint
        base.layer.addSublayer(bgLayer)
        return self
    }
    
    /// 截图
    func screenShot() -> UIImage? {
        guard base.frame.size.height > 0 && base.frame.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(base.frame.size, false, 0)
        base.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var size: CGSize {
        get {
            return base.frame.size
        }
        set {
            base.sl.width = newValue.width
            base.sl.height = newValue.height
        }
    }
      
    var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            base.frame.size.width = newValue
        }
    }
      
    var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            base.frame.size.height = newValue
        }
    }
    
    static var reuseIdentifier: String {
        return String(describing: Base.self)
    }
}

// MARK: - 描边、圆角等
public extension UIView {
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    var kBorderColor: UIColor? {
        set {
            guard let color = newValue else { return }
            self.layer.borderColor = color.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    var kBorderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    var kCornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    var kCornerRadiusNotClip: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    /// Should the corner be as circle
    var kCircleCorner: Bool {
        set {
            kCornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : kCornerRadius
        }
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == kCornerRadius
        }
    }
    
    @IBInspectable
    /// Should the corner be as circle
    var kCircleCornerNotClip: Bool {
        set {
            kCornerRadiusNotClip = newValue ? min(bounds.size.height, bounds.size.width) / 2 : kCornerRadiusNotClip
        }
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == kCornerRadiusNotClip
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    var kShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    var kShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    var kShadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    var kShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    var kShadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }

    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }

    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }

    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}
