//
//  SLUIViewExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// MARK: -
public extension UIView {
    
    /// 在屏幕上的位置,相对于屏幕,不是相对于SuperView
    var sl_frameOnScreen: CGRect {
        let window = UIApplication.shared.windows[0]
        let rect = self.convert(bounds, to: window)
        return rect
    }
    
    /// 从xib加载view
    /// - Parameter module: 从哪个模块
    /// - Returns: view
    static func sl_loadNib(from module: String? = nil) -> UIView? {
        let bundle = Bundle.sl_moduleBundle(self, module) ?? Bundle.main
        return bundle.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? UIView
    }
}

public extension UIView {
    //返回该view所在VC
    func sl_superVC() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    //返回该view所在的父view
    func sl_superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}

public extension UIView {
    
    func removeAllSubviews() {
        while subviews.count > 0 {
            subviews.last?.removeFromSuperview()
        }
    }
    
    func addTarget(target: Any?, action: Selector?) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
    
    func tap() -> ControlEvent<UITapGestureRecognizer> {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        return tap.rx.event
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
    
    /// 设置阴影
    func sl_makeCardShadow(_ cornerRadius: CGFloat = 5, opacity: Float = 1) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.21).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = opacity
        layer.shadowRadius = cornerRadius
    }
    
    /// 设置颜色渐变
    func sl_makeGradientColor(_ colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = colors
        bgLayer.locations = locations
        bgLayer.frame = bounds
        bgLayer.startPoint = startPoint
        bgLayer.endPoint = endPoint
        layer.addSublayer(bgLayer)
    }
    
    /// 截图
     func sl_screenShot() -> UIImage? {
         guard frame.size.height > 0 && frame.size.width > 0 else {
             return nil
         }
         UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
         layer.render(in: UIGraphicsGetCurrentContext()!)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image
     }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
      
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
      
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
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

public extension UIImageView {
    private static let browseEnableKey = UnsafeRawPointer(bitPattern:"browseEnableKey".hashValue)!
    private static let browseTapKey = UnsafeRawPointer(bitPattern:"browseTapKey".hashValue)!

    var browseEnable: Bool {
        get {
            return objc_getAssociatedObject(self, UIImageView.browseEnableKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, UIImageView.browseEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                isUserInteractionEnabled = true
                let tap = browseTap ?? UITapGestureRecognizer(target: self, action: #selector(showImageBrowse))
                addGestureRecognizer(tap)
                browseTap = tap
            } else if let tap = browseTap {
                self.removeGestureRecognizer(tap)
            }
        }
    }
    private var browseTap: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, UIImageView.browseTapKey) as? UITapGestureRecognizer
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, UIImageView.browseTapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var browse: Bool {
        set {
            browseEnable = newValue
        }
        get {
            return browseEnable
        }
    }
    
    @objc private func showImageBrowse() {
        if browseEnable, let image = image {
            SLImageBrower.browser([image]).show()
        }
    }
}
