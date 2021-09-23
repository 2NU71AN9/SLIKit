//
//  Ex_UserDefaults.swift
//  SLIKit
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension SLEx where Base: UserDefaults {
    /// 保存自定义的对象,需要对象实现解归档
    ///
    /// - Parameters:
    ///   - object: 要保存的对象
    ///   - key: key
    @discardableResult
    func saveObject(_ object: NSCoding, key: String) -> SLEx {
        let encodedObject = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
        base.set(encodedObject, forKey: key)
        base.synchronize()
        return self
    }
    
    /// 根据key获取保存的对象,需要对象实现解归档
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: key
    /// - Returns: 对象
    func getDecodedObject<T>(type: T.Type, forKey key: String) -> T? {
        let decodedObject = base.object(forKey: key) as? Data
        if let decoded = decodedObject {
            let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
            return object as? T
        }
        return nil
    }
}
