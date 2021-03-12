//
//  Ex_Label.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

public extension SLEx where Base: UILabel {

    @discardableResult
    func text(_ text: String) -> SLEx {
        base.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor?) -> SLEx {
        base.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> SLEx {
        base.font = font
        return self
    }
    
    @discardableResult
    func number(_ ofLines: Int) -> SLEx {
        base.numberOfLines = ofLines
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> SLEx {
        base.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func line(_ breakMode: NSLineBreakMode) -> SLEx {
        base.lineBreakMode = breakMode
        return self
    }
    
    /// label添加中划线
    ///
    /// - Parameters:
    ///   - text: 内容
    ///   - value: value 越大,划线越粗
    func centerLine(_ text: String, value: Int = 2) {
        let arrText = NSMutableAttributedString(string: text)
        arrText.addAttribute(NSAttributedString.Key.strikethroughStyle, value:value, range:  NSMakeRange(0, arrText.length))
        base.attributedText = arrText
    }
}
