//
//  Ex_HUD.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import PKHUD

public extension HUD {
    static func showToast(_ title: String?, delay: TimeInterval = 1.5, completion: ((Bool) -> Void)? = nil) {
        guard let title = title else { return }
        HUD.flash(.label(title), delay: delay, completion: completion)
    }
    static func showFlashToast(_ title: String?, msg: String? = nil, delay: TimeInterval = 1.5, completion: ((Bool) -> Void)? = nil) {
        HUD.flash(.labeledSuccess(title: title, subtitle: msg), delay: delay, completion: completion)
    }
}
