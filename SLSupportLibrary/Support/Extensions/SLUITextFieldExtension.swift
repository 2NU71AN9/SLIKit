//
//  SLUITextFieldExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class SLNoPasteTextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(paste(_:)):
            return false //粘贴
        case #selector(select(_:)):
            return false //选择
        case #selector(selectAll(_:)):
            return false //全选
        case #selector(cut(_:)):
            return false //剪切
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

public extension UITextField {
    private static let maxCountKey = UnsafeRawPointer(bitPattern:"maxCountKey".hashValue)!
    private static let maxCountBagKey = UnsafeRawPointer(bitPattern:"maxCountBagKey".hashValue)!
    
    var sl_maxCount: Int? {
        get {
            return objc_getAssociatedObject(self, UITextField.maxCountKey) as? Int
        }
        set {
            if let maxCount = newValue {
                objc_setAssociatedObject(self, UITextField.maxCountKey, maxCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                disposeBag = DisposeBag()
                rx.textInput.text.orEmpty
                    .subscribe(onNext: {[weak self] (text) in
                        if text.count > maxCount {
                            self?.text = String(text.prefix(maxCount))
                        }
                    }).disposed(by: disposeBag)
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
    
    /// 小数点后可以输入几位
    var sl_pointCount: Int? {
        get {
            return objc_getAssociatedObject(self, UITextField.pointCountKey) as? Int
        }
        set {
            if let pointCount = newValue {
                objc_setAssociatedObject(self, UITextField.pointCountKey, pointCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                pointDisposeBag = DisposeBag()
                rx.textInput.text.orEmpty
                    .subscribe(onNext: {[weak self] (text) in
                        self?.checkPoint(text)
                    }).disposed(by: pointDisposeBag)
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
        let agoText = input.subString(start: 0, length: input.count - 1)
        let newValue = input.subString(start: input.count-1, length: 1)
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
}
