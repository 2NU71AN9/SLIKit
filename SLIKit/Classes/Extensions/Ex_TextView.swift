//
//  Ex_TextView.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2021/1/13.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit
import RxSwift

/// 没有复制,粘贴,选择等的输入框
public class SLNoPasteTextView: UITextView {
    
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

public extension SLEx where Base: UITextView {
    /// 最大字符数, 0为无限
    @discardableResult
    func maxCount(_ count: Int) -> SLEx {
        base.sl_maxCount = count
        return self
    }
}

public extension UITextView {
    private static let maxCountKey = UnsafeRawPointer(bitPattern:"maxCountKey".hashValue)!
    private static let maxCountBagKey = UnsafeRawPointer(bitPattern:"maxCountBagKey".hashValue)!
    
    /// 最大字符数
    var sl_maxCount: Int? {
        get {
            return objc_getAssociatedObject(self, UITextView.maxCountKey) as? Int
        }
        set {
            if let maxCount = newValue {
                objc_setAssociatedObject(self, UITextView.maxCountKey, maxCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            var bag = objc_getAssociatedObject(self, UITextView.maxCountBagKey) as? DisposeBag
            if bag == nil {
                bag = DisposeBag()
                objc_setAssociatedObject(self, UITextView.maxCountBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return bag!
        }
        set {
            objc_setAssociatedObject(self, UITextView.maxCountBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 最大字符数
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
