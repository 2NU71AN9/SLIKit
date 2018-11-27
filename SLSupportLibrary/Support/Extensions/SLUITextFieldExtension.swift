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

public extension UITextField {
    
    /// 限制输入框的可输入的最大长度
    func sl_maxCount(_ count: Int) {
        _ = rx.textInput.text.orEmpty
            .subscribe(onNext: {[weak self] (text) in
                if text.count > count {
                    self?.text = String(text.prefix(count))
                }
            })
    }
}

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
