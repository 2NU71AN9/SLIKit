//
//  SLCGFloatExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

/// 屏幕适配
public extension CGFloat {
    /// CGFloat -> String
    var sl_2String: String { return String(describing: self) }
    
    /// 屏幕宽度
    var W: CGFloat { return SCREEN_WIDTH/375*self }
    /// 屏幕高度
    var H: CGFloat { return SCREEN_HEIGHT/667*self }
}
