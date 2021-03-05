//
//  Ex_Dictionary.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension SLEx where Base == Dictionary<String, Any> {
    /// 添加可选值
    @discardableResult
    func addOptional(_ item: [String: Any?]) -> Base {
        let keys = Array(item.keys) as [String]
        var dict = base
        for key in keys {
            if item[key] != nil {
                dict[key] = item[key]!
            }
        }
        return dict
    }
}
