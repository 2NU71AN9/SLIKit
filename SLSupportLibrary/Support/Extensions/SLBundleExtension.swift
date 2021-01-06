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
