//
//  Ex_SnapKit.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/12/17.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import SnapKit

public extension ConstraintViewDSL {
    func sl_makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = target as? UIView,
            target.superview != nil else {
            return
        }
        makeConstraints(closure)
    }

    func sl_remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = target as? UIView,
            target.superview != nil else {
            return
        }
        remakeConstraints(closure)
    }

    func sl_updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = target as? UIView,
            target.superview != nil else {
            return
        }
        updateConstraints(closure)
    }
}

