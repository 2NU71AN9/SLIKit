//
//  SLUserDefaultsExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// 保存自定义的对象,需要对象实现解归档
    ///
    /// - Parameters:
    ///   - object: 要保存的对象
    ///   - key: key
    func sl_saveCustomObject(_ object: NSCoding, key: String) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        self.set(encodedObject, forKey: key)
        self.synchronize()
    }
    
    /// 根据key获取保存的对象,需要对象实现解归档
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: key
    /// - Returns: 对象
    func sl_getCustomObject<T>(type: T.Type, forKey key: String) -> T? {
        
        let decodedObject = self.object(forKey: key) as? Data
        if let decoded = decodedObject {
            let object = NSKeyedUnarchiver.unarchiveObject(with: decoded)
            return object as? T
        }
        return nil
    }
}
