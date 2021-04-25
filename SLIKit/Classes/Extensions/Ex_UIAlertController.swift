//
//  Ex_UIAlertController.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/12/17.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

public extension SLEx where Base: UIAlertController {
    static func show(parent: UIViewController?, title: String?, message: String?, cancelTitle: String?, confirmTitle: String?, cancelComplete: (() -> Void)?, confirmComplete: (() -> Void)?) {
        weak var parent = parent
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelTitle = cancelTitle {
            let ac = UIAlertAction(title: cancelTitle, style: .default) { (_) in
                cancelComplete?()
            }
            alert.addAction(ac)
        }
        if let confirmTitle = confirmTitle {
            let ac = UIAlertAction(title: confirmTitle, style: .default) { (_) in
                confirmComplete?()
            }
            alert.addAction(ac)
        }
        parent?.present(alert, animated: true, completion: nil)
    }
    
    @discardableResult
    func show(_ vc: UIViewController? = SL.visibleVC, block: (() -> Void)? = nil) -> SLEx {
        if base.title == nil && base.message == nil && base.actions.count == 0 {
            assertionFailure("👻💀大哥！你别什么东西都不放💀👻")
            return self
        }
        vc?.present(base, animated: true, completion: block)
        return self
    }
    
    @discardableResult
    func hidden(_ time: TimeInterval, block: (() -> Void)? = nil) -> SLEx {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak base] in
            base?.dismiss(animated: true, completion: block)
        }
        return self
    }
    
    @discardableResult
    static func alert(_ style: UIAlertController.Style) -> SLEx<UIAlertController> {
        UIAlertController(title: nil, message: nil, preferredStyle: style).sl
    }
    
    @discardableResult
    func title(_ a: String) -> SLEx {
        base.title = a
        return self
    }
    
    @discardableResult
    func title(_ font: UIFont) -> SLEx {
        let attributed: NSAttributedString = base.value(forKey: "attributedTitle") as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedTitle")
        return self
    }
    
    @discardableResult
    func title(_ color: UIColor) -> SLEx {
        let attributed: NSAttributedString = base.value(forKey: "attributedTitle") as? NSAttributedString ?? NSMutableAttributedString(string: base.title ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedTitle")
        return self
    }
    
    @discardableResult
    func title(_ attributed: NSAttributedString) -> SLEx {
        base.setValue(attributed, forKey: "attributedTitle")
        return self
    }
    
    @discardableResult
    func message(_ a: String) -> SLEx {
        base.message = a
        return self
    }
    
    @discardableResult
    func message(_ font: UIFont) -> SLEx {
        let attributed: NSAttributedString = base.value(forKey: "attributedMessage") as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedMessage")
        return self
    }
    
    @discardableResult
    func message(_ color: UIColor) -> SLEx {
        let attributed: NSAttributedString = base.value(forKey: "attributedMessage") as? NSAttributedString ?? NSMutableAttributedString(string: base.message ?? "")
        let attributedM = NSMutableAttributedString(attributedString: attributed)
        attributedM.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedM.length))
        base.setValue(attributedM, forKey: "attributedMessage")
        return self
    }
    
    @discardableResult
    func message(_ attributed: NSAttributedString) -> SLEx {
        base.setValue(attributed, forKey: "attributedMessage")
        return self
    }
    
    @discardableResult
    func action(_ title: String = "",
                style: UIAlertAction.Style = .default,
                custom: ((UIAlertAction) -> Void)? = nil,
                handler: ((UIAlertAction) -> Void)? = nil) -> SLEx {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        custom?(action)
        base.addAction(action)
        return self
    }
    
    @discardableResult
    func add(action: UIAlertAction) -> SLEx {
        base.addAction(action)
        return self
    }
}
