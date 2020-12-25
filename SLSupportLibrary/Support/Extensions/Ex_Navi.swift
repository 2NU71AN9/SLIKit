//
//  Ex_Navi.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

public extension UINavigationController {
    final func removeAllCenterVC() {
        if let first = viewControllers.first,
            let last = viewControllers.last {
            viewControllers = [first, last]
        }
    }
}
