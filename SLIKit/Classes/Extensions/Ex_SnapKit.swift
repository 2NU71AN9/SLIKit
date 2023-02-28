//
//  Ex_SnapKit.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/12/17.
//  Copyright © 2020 SL. All rights reserved.
//

#if canImport(SnapKit)

import UIKit
import SnapKit

extension ConstraintViewDSL: SLExCompatible {}

public extension SLEx where Base == ConstraintViewDSL {
    func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = base.target as? UIView,
            target.superview != nil else {
            return
        }
        base.makeConstraints(closure)
    }

    func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = base.target as? UIView,
            target.superview != nil else {
            return
        }
        base.remakeConstraints(closure)
    }

    func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = base.target as? UIView,
            target.superview != nil else {
            return
        }
        base.updateConstraints(closure)
    }
}
#endif
