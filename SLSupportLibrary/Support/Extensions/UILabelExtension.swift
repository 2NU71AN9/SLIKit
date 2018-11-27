//
//  UILabelExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {

    /// label添加中划线
    ///
    /// - Parameters:
    ///   - text: 内容
    ///   - value: value 越大,划线越粗
    func sl_centerLineText(text: String, value: Int = 2) {
        let arrText = NSMutableAttributedString(string: text)
        arrText.addAttribute(NSAttributedString.Key.strikethroughStyle, value:value, range:  NSMakeRange(0, arrText.length))
        attributedText = arrText
    }
}
