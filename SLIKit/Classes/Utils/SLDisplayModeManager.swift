//
//  SLDisplayModeManager.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/14.
//

import UIKit

@available(iOS 13.0, *)
public class SLDisplayModeManager: NSObject {
    
    /// 当前模式
    public var currentMode: SLDisplayMode {
        guard let style = SL.WINDOW?.overrideUserInterfaceStyle else { return .flowSystem(.light) }
        if style == .unspecified {
            return .flowSystem(SLDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue))
        }
        return SLDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue)
    }
    
    private static let kDisplayModeKey = "kDisplayModeKey"
    
    public static let shared = SLDisplayModeManager()
    
    private override init() {
        super.init()
        if let mode = UserDefaults.standard.value(forKey: Self.kDisplayModeKey) as? Int {
            setDisplayMode(SLDisplayMode.makeMode(mode))
        }
    }
    
    /// 设置显示模式
    public func setDisplayMode(_ mode: SLDisplayMode) {
        var realModel = mode
        switch mode {
        case .flowSystem:
            realModel = .flowSystem(SLDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue))
            UserDefaults.standard.removeObject(forKey: Self.kDisplayModeKey)
        default:
            UserDefaults.standard.setValue(mode.rawValue, forKey: Self.kDisplayModeKey)
        }
        SL.WINDOW?.overrideUserInterfaceStyle = realModel.userInterfaceStyle
    }
    
    public func setup() { }
}

@available(iOS 13.0, *)
public enum SLDisplayMode {
    
    indirect case flowSystem(SLDisplayMode?)
    case light
    case dark
    
    public var rawValue: Int {
        switch self {
        case .flowSystem:
            return 0
        case .light:
            return 1
        case .dark:
            return 2
        }
    }
    
    public static func makeMode(_ value: Int) -> SLDisplayMode {
        switch value {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return .flowSystem(.light)
        }
    }
    
    public var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .flowSystem:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return.dark
        }
    }
}
