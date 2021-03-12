//
//  StringInterpolation.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/11/14.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

struct ColorString: ExpressibleByStringInterpolation {
    
    // 嵌套结构，插入带属性的字符串
    struct StringInterpolation: StringInterpolationProtocol {

        // 存储带属性字符串
        var output = NSMutableAttributedString()
        // 默认的字符串属性
        var baseAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black]
        // 必须的,创建时可用于优化性能
        init(literalCapacity: Int, interpolationCount: Int) {}

        // 添加默认文字时
        mutating func appendLiteral(_ literal: String) {
            let attributedString = NSAttributedString(string: literal, attributes: baseAttributes)
            output.append(attributedString)
        }
        
        // 添加带颜色的文字时
        mutating func appendInterpolation(message: String, color: UIColor, font: UIFont) {
            var colorAtt = baseAttributes
            colorAtt[.foregroundColor] = color
            colorAtt[.font] = font
            let attStr = NSAttributedString(string: message, attributes: colorAtt)
            output.append(attStr)
        }
    }
    
    // 所有文字处理完成后，存储最终的文字
    let value: NSAttributedString
    // 从普通字符串初始化
    init(stringLiteral value: StringLiteralType) {
        self.value = NSAttributedString(string: value)
    }
    
    // 从带颜色的字符串初始化
    init(stringInterpolation: StringInterpolation) {
        self.value = stringInterpolation.output
    }
}
