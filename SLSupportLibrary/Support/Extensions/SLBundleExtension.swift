//
//  SLBundleExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension Bundle {
    /// 命名空间
    var namespace: String { return infoDictionary?["CFBundleName"] as? String ?? "" }
}
