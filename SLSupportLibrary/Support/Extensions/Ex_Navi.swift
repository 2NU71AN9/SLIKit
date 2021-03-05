//
//  Ex_Navi.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

public extension SLEx where Base: UINavigationController {
    
    @discardableResult
    func removeCenterVC() -> SLEx {
        if let first = base.viewControllers.first,
           let last = base.viewControllers.last {
            base.viewControllers = [first, last]
        }
        return self
    }
}
