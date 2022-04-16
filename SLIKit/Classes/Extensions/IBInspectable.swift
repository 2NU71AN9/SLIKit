//
//  IBInspectable.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/14.
//

import UIKit

// MARK: - 描边、圆角等
public extension UIView {
    
    /// 宽度=屏幕宽度的多少倍再加上/减去多少, width代表倍数 100为1倍
    @IBInspectable
    var wEs1: CGSize {
        get { CGSize.zero }
        set {
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * (newValue.width / 100) + newValue.height).isActive = true
        }
    }
    
    /// 宽度=屏幕宽度加上/减去多少再乘以倍数, width代表倍数 100为1倍
    @IBInspectable
    var wEs2: CGSize {
        get { CGSize.zero }
        set {
            widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width + newValue.height) * (newValue.width / 100)).isActive = true
        }
    }
    
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

// MARK: - 本地化相关

public extension UILabel {
    @IBInspectable
    var ltText: String? {
        set {
            guard let newValue = newValue else { return }
            text = NSLocalizedString(newValue, comment: "")
        }
        get {
            return nil
        }
    }
}

public extension UIButton {
    @IBInspectable
    var ltTitleNormal: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .normal)
        }
        get {
            return nil
        }
    }
    @IBInspectable
    var ltTitleHighlighted: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .highlighted)
        }
        get {
            return nil
        }
    }
    @IBInspectable
    var ltTitleSelected: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .selected)
        }
        get {
            return nil
        }
    }
    @IBInspectable
    var ltTitleDisabled: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .disabled)
        }
        get {
            return nil
        }
    }
    @IBInspectable
    var ltTitleFocused: String? {
        set {
            guard let newValue = newValue else { return }
            setTitle(NSLocalizedString(newValue, comment: ""), for: .focused)
        }
        get {
            return nil
        }
    }
}

public extension UITextField {
    @IBInspectable
    var ltText: String? {
        set {
            guard let newValue = newValue else { return }
            text = NSLocalizedString(newValue, comment: "")
        }
        get {
            return nil
        }
    }
    @IBInspectable
    var ltPlaceholder: String? {
        set {
            guard let newValue = newValue else { return }
            placeholder = NSLocalizedString(newValue, comment: "")
        }
        get {
            return nil
        }
    }
}

public extension UITextView {
    @IBInspectable
    var ltText: String? {
        set {
            guard let newValue = newValue else { return }
            text = NSLocalizedString(newValue, comment: "")
        }
        get {
            return nil
        }
    }
}
