//
//  StringInterpolation.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/11/14.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

public struct ColorString: ExpressibleByStringInterpolation {
    
    // 嵌套结构，插入带属性的字符串
    public struct StringInterpolation: StringInterpolationProtocol {

        // 存储带属性字符串
        var output = NSMutableAttributedString()
        // 默认的字符串属性
        var baseAttributes: [NSAttributedString.Key: Any] = [:]
        // 必须的,创建时可用于优化性能
        public init(literalCapacity: Int, interpolationCount: Int) {}

        // 添加默认文字时
        mutating public func appendLiteral(_ literal: String) {
            let attributedString = NSAttributedString(string: literal, attributes: baseAttributes)
            output.append(attributedString)
        }
        
        // 添加带颜色的文字时
        public mutating func appendInterpolation(message: String, color: UIColor, font: UIFont) {
            var colorAtt = baseAttributes
            colorAtt[.foregroundColor] = color
            colorAtt[.font] = font
            let attStr = NSAttributedString(string: message, attributes: colorAtt)
            output.append(attStr)
        }
    }
    
    // 所有文字处理完成后，存储最终的文字
    public let value: NSAttributedString
    // 从普通字符串初始化
    public init(stringLiteral value: StringLiteralType) {
        self.value = NSAttributedString(string: value)
    }
    
    // 从带颜色的字符串初始化
    public init(stringInterpolation: StringInterpolation) {
        self.value = stringInterpolation.output
    }
}
