//
//  Ex_ViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/11.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit

public extension SLEx where Base: UIViewController {
    @discardableResult
    func push(_ animated: Bool) -> SLEx {
        SL.visibleVC?.navigationController?.pushViewController(base, animated: animated)
        return self
    }
    
    @discardableResult
    func pop(_ animated: Bool) -> SLEx {
        base.navigationController?.popViewController(animated: animated)
        return self
    }
    
    @discardableResult
    func present(_ animated: Bool, completion: (() -> Void)?) -> SLEx {
        SL.visibleVC?.present(base, animated: animated, completion: completion)
        return self
    }
    
    @discardableResult
    func dismiss(_ animated: Bool, completion: (() -> Void)?) -> SLEx {
        base.dismiss(animated: animated, completion: completion)
        return self
    }
}
