//
//  SLUITextViewExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift

public extension UITextView {
    
    /// 限制输入框的可输入的最大长度
    func sl_maxCount(_ count: Int) {
        _ = rx.textInput.text.orEmpty
            .subscribe(onNext: {[weak self] (text) in
                if text.count > count {
                    self?.text = String(text.prefix(count))
                }
            })
    }
    
    /// 设置textView的placeholer,在设置完textview的frame,textAlignment,font后使用
    ///
    /// - Parameters:
    ///   - text: 提示内容
    ///   - topGap: 距离顶部的距离
    func sl_placeholder(_ text: String?, topGap: CGFloat? = 4) {
        guard let text = text else { return }
        let textLabel = UILabel().then {
            $0.text = text
            $0.font = font
            $0.textAlignment = textAlignment
            $0.textColor = UIColor.lightGray
            $0.isHidden = hasText
            addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(topGap!)
                make.centerX.equalToSuperview()
                make.size.equalTo(contentSize)
                switch textAlignment {
                case .left:
                    make.leading.equalToSuperview().offset(4)
                case .center:
                    make.centerX.equalToSuperview()
                case .right:
                    make.trailing.equalToSuperview().offset(-4)
                default:
                    make.leading.equalToSuperview().offset(4)
                }
            }
        }
        _ = rx.text.orEmpty.subscribe { [weak self] (event) in
            textLabel.isHidden = self?.hasText ?? true
        }
    }
}
