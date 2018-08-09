//
//  SLColorExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    /// 十六进制颜色
    ///
    /// - Parameter hex: 16进制的数字
    /// - Returns: UIColor
    class func sl_hexColor(hex: uint) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return sl_RGBColor(R: Float(r), G: Float(g), B: Float(b))
    }
    
    /// 随机颜色
    ///
    /// - Returns: UIColor
    class func sl_randomColor() -> UIColor {
        return sl_RGBColor(R: Float(arc4random_uniform(256)),
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
    class func sl_RGBColor(R: Float, G: Float, B: Float, alpha: Float = 1) -> UIColor {
        return UIColor.init(red: CGFloat(R/255.0), green: CGFloat(G/255.0), blue: CGFloat(B/255.0), alpha: 1)
    }
    
    /// 颜色生成纯色图片
    var sl_2Image: UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
