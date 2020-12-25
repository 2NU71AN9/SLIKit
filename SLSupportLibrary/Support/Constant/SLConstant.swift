//
//  SLConstant.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit

// MARK: - =============屏幕相关=============
/// 屏幕宽度
public var SCREEN_WIDTH: CGFloat { return UIScreen.main.bounds.width }
/// 屏幕高度
public var SCREEN_HEIGHT: CGFloat { return UIScreen.main.bounds.height }
/// 屏幕分辨率
public var SCREEN_SCALE: CGFloat { return UIScreen.main.scale }
/// 屏幕大小
public var SCREEN_BOUNS: CGRect { return UIScreen.main.bounds }
/// 屏幕中心点
public var SCREEN_CENTER: CGPoint { return CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2) }
/// 是否是iPhoneX
public var isiPhoneX: Bool { return UIApplication.shared.statusBarFrame.height > 20 }
/// 电池栏高度
public let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
/// 导航栏高度
public let naviCtrHeight: CGFloat = statusBarHeight + 44
/// tabBar高度 普通49 iPhoneX 83
public let tabBarHeight: CGFloat = bottomHeight + 49
/// 底部SafeArea高度 普通0 iPhoneX 34
public let bottomHeight: CGFloat = isiPhoneX ? 34 : 0


// MARK: - =============获取当前显示的控制器=============
public weak var cur_visible_vc: UIViewController? {
    weak var vc = UIApplication.shared.keyWindow?.rootViewController
    while true {
        if vc?.isKind(of: UITabBarController.self) ?? false {
            vc = (vc as? UITabBarController)?.selectedViewController
        } else if vc?.isKind(of: UINavigationController.self) ?? false {
            vc = (vc as? UINavigationController)?.visibleViewController
        } else if vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }else{
            break
        }
    }
    return vc
}
