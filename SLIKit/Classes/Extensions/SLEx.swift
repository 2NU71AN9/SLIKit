//
//  SLEx.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2021/3/4.
//  Copyright © 2021 SL. All rights reserved.
//

import Foundation
import UIKit

public final class SLEx<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public var build: Base {
        return base
    }
}

public protocol SLExCompatible {
    associatedtype CompatibleType
    var sl: CompatibleType { get }
    static var sl: CompatibleType.Type { get }
}
public extension SLExCompatible {
    var sl: SLEx<Self> {
        return SLEx(self)
    }
    static var sl: SLEx<Self>.Type {
        return SLEx.self
    }
}

extension NSObject: SLExCompatible {}
extension String: SLExCompatible {}
extension Int: SLExCompatible {}
extension Double: SLExCompatible {}
extension Float: SLExCompatible {}
extension CGFloat: SLExCompatible {}
extension Date: SLExCompatible {}
extension Dictionary: SLExCompatible {}
extension Array: SLExCompatible {}
