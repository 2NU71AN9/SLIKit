//
//  Ex_ImageView.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/4.
//  Copyright © 2021 SL. All rights reserved.
//

import Foundation
import UIKit

public extension SLEx where Base: UIImageView {
    
    @discardableResult
    func image(_ image: UIImage?) -> SLEx {
        base.image = image
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> SLEx {
        base.contentMode = mode
        return self
    }
    
    @discardableResult
    func browseEnable(_ a: Bool) -> SLEx {
        base.sl_browseEnable = a
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.sl_show()
        return self
    }
}

public extension UIImageView {
    private static let browseEnableKey = UnsafeRawPointer(bitPattern:"browseEnableKey".hashValue)!
    private static let browseTapKey = UnsafeRawPointer(bitPattern:"browseTapKey".hashValue)!

    var sl_browseEnable: Bool {
        get {
            return objc_getAssociatedObject(self, UIImageView.browseEnableKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, UIImageView.browseEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                isUserInteractionEnabled = true
                let tap = browseTap ?? UITapGestureRecognizer(target: self, action: #selector(sl_show))
                addGestureRecognizer(tap)
                browseTap = tap
            } else if let tap = browseTap {
                removeGestureRecognizer(tap)
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
            sl_browseEnable = newValue
        }
        get {
            return sl_browseEnable
        }
    }
    
    @objc fileprivate func sl_show() {
        if let image = image {
            SLImageBrower.browser([image]).show()
        }
    }
}
