//
//  SLDictionaryExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// 添加可选值
    func sl_addOptional(_ item: [String: Any?]) -> Dictionary {
        guard let keys = Array(item.keys) as? [String],
            var dict = self as? [String: Any] else {
                return self
        }
        for key in keys {
            if item[key] != nil {
                dict[key] = item[key]!
            }
        }
        return dict as! Dictionary<Key, Value>
    }
}
