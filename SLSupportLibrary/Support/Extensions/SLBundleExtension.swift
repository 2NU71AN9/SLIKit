//
//  SLBundleExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension Bundle {
    var sl_app_version: String? { return infoDictionary?["CFBundleShortVersionString"] as? String }
    var sl_app_build: String? { return infoDictionary?["CFBundleVersion"] as? String }
    var sl_app_name: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
    var sl_app_bundleIdentifier: String? { return infoDictionary?["CFBundleIdentifier"] as? String }
    /// 命名空间
    var sl_namespace: String? { return infoDictionary?["CFBundleName"] as? String }
}

public extension Bundle {
    /// 获取资源bundle, 加载图片 文件等资源
    static func sl_loadBundle(cls: AnyClass, bundleName: String) -> Bundle? {
        let bundle = Bundle(for: cls)
        guard let path = bundle.path(forResource: bundleName, ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }
    
    /// 跨模块获取bundle, 获取xib storyboard
    static func sl_moduleBundle(_ forClass: AnyClass, _ module: String? = nil) -> Bundle? {
        let bundle = Bundle(for: forClass)
        guard let bundleURL = bundle.url(forResource: module, withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: bundleURL)
    }
}
