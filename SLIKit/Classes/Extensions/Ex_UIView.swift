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
        let rect = base.convert(base.bounds, to: SL.WINDOW)
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
    
    
    /// SwifterSwift: 摇动视图的方向
    ///
    /// - horizontal: 水平
    /// - vertical: 垂直
    enum ShakeDirection {
        case horizontal
        case vertical
    }
    /// SwifterSwift: 摇动动画类型
    ///
    /// - linear: 线性动画
    /// - easeIn: 缓入动画
    /// - easeOut: 缓出动画
    /// - easeInOut: 缓入缓出动画
    enum ShakeAnimationType {
        case linear
        case easeIn
        case easeOut
        case easeInOut
    }
    
    /// SwifterSwift: 摇动视图.
    ///
    /// - Parameters:
    ///   - direction: 摇动方向（水平或垂直），（默认为 .horizontal）
    ///   - duration: 以秒为单位的动画持续时间（默认为 1 秒）。
    ///   - animationType: 摇动动画类型（默认为 .easeOut）。
    ///   - completion: 在动画完成时运行的可选完成处理程序（默认值为 nil）。
    @discardableResult
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 0.6, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) -> SLEx? {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-15.0, 12.0, -8.0, 8.0, -3.0, 3.0, 0.0]
        base.layer.add(animation, forKey: "shake")
        CATransaction.commit()
        return self
    }
}
