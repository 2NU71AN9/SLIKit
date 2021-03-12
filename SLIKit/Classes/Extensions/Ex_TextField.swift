//
//  Ex_TextField.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/// 没有复制,粘贴,选择等的输入框
public class SLNoPasteTextField: UITextField {
    
    @IBInspectable public dynamic var perform: Bool = true
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(paste(_:)), #selector(select(_:)), #selector(selectAll(_:)), #selector(cut(_:)):
            return perform
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

public extension SLEx where Base: UITextField {
    /// 最大字符数, 0为不限
    @discardableResult
    func maxCount(_ count: Int) -> SLEx {
        base.sl_maxCount = count
        return self
    }
    
    /// 小数点后可以输入几位, -1为不限
    @discardableResult
    func pointCount(_ count: Int) -> SLEx {
        base.sl_pointCount = count
        return self
    }
}


public extension UITextField {
    private static let maxCountKey = UnsafeRawPointer(bitPattern:"maxCountKey".hashValue)!
    private static let maxCountBagKey = UnsafeRawPointer(bitPattern:"maxCountBagKey".hashValue)!
    
    /// 最大字符数, 0为不限
    var sl_maxCount: Int? {
        get {
            return objc_getAssociatedObject(self, UITextField.maxCountKey) as? Int
        }
        set {
            if let maxCount = newValue {
                objc_setAssociatedObject(self, UITextField.maxCountKey, maxCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                disposeBag = DisposeBag()
                if maxCount > 0 {
                    rx.textInput.text.orEmpty
                        .subscribe(onNext: {[weak self] (text) in
                            if text.count > maxCount {
                                self?.text = String(text.prefix(maxCount))
                            }
                        }).disposed(by: disposeBag)
                }
            }
        }
    }
    
    private var disposeBag: DisposeBag {
        get {
            var bag = objc_getAssociatedObject(self, UITextField.maxCountBagKey) as? DisposeBag
            if bag == nil {
                bag = DisposeBag()
                objc_setAssociatedObject(self, UITextField.maxCountBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return bag!
        }
        set {
            objc_setAssociatedObject(self, UITextField.maxCountBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 最大字符数, 0为不限
    @IBInspectable
    var maxCount: Int {
        get {
            return sl_maxCount ?? 0
        }
        set {
            sl_maxCount = newValue
        }
    }
}


public extension UITextField {
    
    private static let pointCountKey = UnsafeRawPointer(bitPattern:"pointCountKey".hashValue)!
    private static let pointCountBagKey = UnsafeRawPointer(bitPattern:"pointCountBagKey".hashValue)!
    
    /// 小数点后可以输入几位, -1为不限
    var sl_pointCount: Int? {
        get {
            return objc_getAssociatedObject(self, UITextField.pointCountKey) as? Int
        }
        set {
            if let pointCount = newValue {
                objc_setAssociatedObject(self, UITextField.pointCountKey, pointCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                pointDisposeBag = DisposeBag()
                if pointCount >= 0 {
                    rx.textInput.text.orEmpty
                        .subscribe(onNext: {[weak self] (text) in
                            self?.checkPoint(text)
                        }).disposed(by: pointDisposeBag)
                }
            }
        }
    }
    
    private var pointDisposeBag: DisposeBag {
        get {
            var bag = objc_getAssociatedObject(self, UITextField.pointCountBagKey) as? DisposeBag
            if bag == nil {
                bag = DisposeBag()
                objc_setAssociatedObject(self, UITextField.pointCountBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return bag!
        }
        set {
            objc_setAssociatedObject(self, UITextField.pointCountBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func checkPoint(_ input: String) {
        if input.count == 0 { return }
        if input == "." {
            text = "0."
            return
        }
        let agoIndex = input.count - 1
        let agoText = input.sl.subString(start: 0, length: input.count - 1)
        let newValue = input.sl.subString(start: input.count-1, length: 1)
        if agoText?.contains(".") ?? false {
            if newValue == "." {
                text = String(input.prefix(agoIndex))
            } else {
                if let subfix = input.components(separatedBy: ".").last,
                   let pointCount = sl_pointCount,
                    subfix.count > pointCount {
                    text = String(input.prefix(agoIndex))
                }
            }
        }
    }
    
    /// 小数点后可以输入几位, -1为不限
    @IBInspectable
    var pointCount: Int {
        get {
            return sl_pointCount ?? 0
        }
        set {
            sl_pointCount = newValue
        }
    }
}
