//
//  SLOperatorCustom.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

/// 去空
postfix operator ~~
public postfix func ~~(a: String?)            -> String            { return a == nil ? "" : a! }
public postfix func ~~(a: Int?)               -> Int               { return a == nil ? 0 : a! }
public postfix func ~~(a: Int8?)              -> Int8              { return a == nil ? 0 : a!}
public postfix func ~~(a: Int16?)             -> Int16             { return a == nil ? 0 : a! }
public postfix func ~~(a: Int32?)             -> Int32             { return a == nil ? 0 : a! }
public postfix func ~~(a: Int64?)             -> Int64             { return a == nil ? 0 : a! }
public postfix func ~~(a: UInt?)              -> UInt              { return a == nil ? 0 : a! }
public postfix func ~~(a: Double?)            -> Double            { return a == nil ? 0 : a! }
public postfix func ~~(a: Float?)             -> Float             { return a == nil ? 0 : a! }
public postfix func ~~(a: CGFloat?)           -> CGFloat           { return a == nil ? 0 : a! }
public postfix func ~~(a: [Any]?)             -> [Any]             { return a == nil ? [] : a! }
public postfix func ~~(a: [String]?)          -> [String]          { return a == nil ? [] : a! }
public postfix func ~~(a: [Int]?)             -> [Int]             { return a == nil ? [] : a! }
public postfix func ~~(a: [String: Any]?)     -> [String: Any]     { return a == nil ? [:] : a! }
public postfix func ~~(a: [String: String]?)  -> [String: String]  { return a == nil ? [:] : a! }
public postfix func ~~(a: UIViewController?)  -> UIViewController  { return a == nil ? UIViewController() : a! }
public postfix func ~~(a: UIView?)  -> UIView  { return a == nil ? UIView() : a! }

/// 字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
