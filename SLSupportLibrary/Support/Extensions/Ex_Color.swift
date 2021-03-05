//
//  Ex_Color.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

public extension SLEx where Base: UIColor {
    /// 十六进制颜色
    ///
    /// - Parameter hex: 16进制的数字
    /// - Returns: UIColor
    static func hex(hex: uint) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return RGB(R: Float(r), G: Float(g), B: Float(b))
    }
    
    /// 随机颜色
    ///
    /// - Returns: UIColor
    static var random: UIColor {
        return RGB(R: Float(arc4random_uniform(256)),
                           G: Float(arc4random_uniform(256)),
                           B: Float(arc4random_uniform(256)))
    }
    
    /// RGB颜色
    ///
    /// - Parameters:
    ///   - R: red
    ///   - G: green
    ///   - B: blue
    ///   - alpha: 透明度
    /// - Returns: UIColor
    static func RGB(R: Float, G: Float, B: Float, alpha: Float = 1) -> UIColor {
        return Base(red: CGFloat(R/255.0), green: CGFloat(G/255.0), blue: CGFloat(B/255.0), alpha: 1)
    }
    
    /// 颜色生成纯色图片
    var image: UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(base.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var hex: String {
        let rgba = self.rgba
        let rs: String = String(Int(rgba.0*255), radix: 16)
        let gs: String = String(Int(rgba.1*255), radix: 16)
        let bs: String = String(Int(rgba.2*255), radix: 16)
        return "#" + rs + gs + bs
    }
    
    var rgba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}
