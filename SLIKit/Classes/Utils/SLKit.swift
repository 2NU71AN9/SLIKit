//
//  SLKit.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/5.
//  Copyright © 2021 SL. All rights reserved.
//

import Foundation
import UIKit
#if canImport(HXPhotoPicker)
import HXPhotoPicker
#endif

public struct SL {
    public static var WINDOW: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                return window
            }
            let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            let window = scene?.windows.first(where: { $0.isKeyWindow })
            return window ?? UIApplication.shared.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    public static var SCREEN_BOUNS: CGRect { UIScreen.main.bounds }
    public static var SCREEN_SIZE: CGSize { SCREEN_BOUNS.size }
    public static var SCREEN_WIDTH: CGFloat { SCREEN_BOUNS.size.width }
    public static var SCREEN_HEIGHT: CGFloat { SCREEN_BOUNS.size.height }
    public static var SCREEN_SCALE: CGFloat { UIScreen.main.scale }
    public static var SCREEN_CENTER: CGPoint { CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2) }
    /// 状态栏高度
    public static var statusBarHeight: CGFloat { WINDOW?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 }
    /// 导航栏高度
    public static var sysNavigationH: CGFloat { statusBarHeight + 44 }
    /// tabBar高度 普通49 iPhoneX 83
    public static var sysTabBarH: CGFloat { bottomHeight + 49 }
    /// 底部SafeArea高度 普通0 iPhoneX 34
    public static var bottomHeight: CGFloat { Device.mode == .iPhoneX ? 34 : 0 }
    
    
    /// 是否模拟器
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

public extension SL {
    
    enum DeviceFit {
        case iPhone320
        case iPhone375
        case iPhone414
        case iPad
        case iTV
        case iCarPlay
        case iUnspecified
        
        public static var mode: DeviceFit {
            func iPhoneToWidth() -> SL.DeviceFit {
                if SCREEN_WIDTH <= 320.0 { return iPhone320 }
                if SCREEN_WIDTH > 320.0 && SCREEN_WIDTH <= 375.0 { return iPhone375 }
                return iPhone414
            }
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                return .iPad
            case .phone:
                return iPhoneToWidth()
            case .tv:
                return .iTV
            case .carPlay:
                return .iCarPlay
            default:
                return iPhoneToWidth()
            }
        }
    }
    
    /// 设备类型
    enum Device {
        /// 4及4一下系列
        case iPhone4
        /// 5及se pod 系列
        case iPhoneSE
        /// 6.7.8...及系列
        case iPhoneA
        /// plus...及系列
        case iPhoneP
        /// X...及系列
        case iPhoneX
        case iPad
        case iTV
        case iCarPlay
        case iUnspecified
        
        public static var mode: Device {
            
            func iPhoneToSize() -> SL.Device {
                if SCREEN_HEIGHT <= 480.0 { return .iPhone4 }
                if (SCREEN_WIDTH == 320.0 && SCREEN_HEIGHT == 568.0)
                    || (SCREEN_HEIGHT == 320.0 && SCREEN_WIDTH == 568.0)
                { return .iPhoneSE }
                if (SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 667.0)
                    || (SCREEN_HEIGHT == 375.0 && SCREEN_WIDTH == 667.0)
                { return .iPhoneA }
                if (SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 736.0)
                    || (SCREEN_HEIGHT == 414.0 && SCREEN_WIDTH == 736.0)
                { return .iPhoneP }
                return .iPhoneX
            }
            
            func iphone() -> Device {
                if #available(iOS 11.0, *) {
                    if let b = WINDOW?.safeAreaInsets.bottom, b > 0 {
                        return .iPhoneX
                    }else{
                        return iPhoneToSize()
                    }
                } else {
                    return iPhoneToSize()
                }
            }
            
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                return .iPad
            case .phone:
                return iphone()
            case .tv:
                return .iTV
            case .carPlay:
                return .iCarPlay
            default:
                return iphone()
            }
        }
    }
    
    // MARK: - =============获取当前显示的控制器=============
    static weak var visibleVC: UIViewController? {
        weak var vc = WINDOW?.rootViewController
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
    
    static weak var topVC: UIViewController? {
        func topVC(_ vc: UIViewController? = nil) -> UIViewController? {
            let vc = vc ?? WINDOW?.rootViewController
            if let nv = vc as? UINavigationController,
                !nv.viewControllers.isEmpty
            {
                return topVC(nv.topViewController)
            }
            if let tb = vc as? UITabBarController,
                let select = tb.selectedViewController
            {
                return topVC(select)
            }
            if let _ = vc?.presentedViewController, let nvc = visibleVC?.navigationController {
                return topVC(nvc)
            }
            return vc
        }
        let vc = WINDOW?.rootViewController
        return topVC(vc)
    }
    
    static func mainThread(_ work: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async(execute: work)
    }
    
    static func delay(second: Double, work: @escaping @convention(block) () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + second, execute: work)
    }
}

public extension SL {
    enum PingFang: String {
        case 极细 = "PingFangSC-Ultralight"
        case 纤细 = "PingFangSC-Thin"
        case 细 = "PingFangSC-Light"
        case 常规 = "PingFangSC-Regular"
        case 中黑 = "PingFangSC-Medium"
        case 中粗 = "PingFangSC-Semibold"

        public static func fontName(_ index: Int) -> PingFang {
            switch index {
            case 1:
                return .极细
            case 2:
                return .纤细
            case 3:
                return .细
            case 4:
                return .常规
            case 5:
                return .中黑
            case 6:
                return .中粗
            default:
                return .常规
            }
        }

        public func size(_ size: CGFloat) -> UIFont? {
            UIFont(name: rawValue, size: size)
        }
        
        public static func font(name: PingFang, size: CGFloat = 17) -> UIFont? {
            UIFont(name: name.rawValue, size: size)
        }
        public static func font(index: Int, size: CGFloat = 17) -> UIFont? {
            UIFont(name: fontName(index).rawValue, size: size)
        }
    }
}

public extension SL {
    static var pickerNormal: SLEx<SLPickerViewController> {
        SLPickerViewController(titles: [], complete: nil).sl
    }
    
    static var pickerTag: SLEx<SLTagPickerViewController> {
        SLTagPickerViewController([""], complete: nil).sl
    }
    
    static var pickerDate: SLEx<SLDatePickerViewController> {
        SLDatePickerViewController(.date, complete: nil).sl
    }
    
    #if canImport(HXPhotoPicker)
    static var pickerImage: SLEx<HXPhotoManager>? {
        let configuration = HXPhotoConfiguration()
        configuration.openCamera = true
        configuration.clarityScale = 2
        let manager = HXPhotoManager(type: .photo)
        manager?.configuration = configuration
        return manager?.sl
    }
    #endif
    
    static var pickerFile: SLEx<SLFilePickerViewController> {
        SLFilePickerViewController(nil).sl
    }
    
    static var pickerAddress: SLEx<SLAddressPickerViewController> {
        SLAddressPickerViewController(.area, complete: nil).sl
    }
}
