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
    func push(_ vc: UIViewController, animated: Bool = true) -> SLEx {
        base.navigationController?.pushViewController(vc, animated: animated)
        return self
    }
    
    @discardableResult
    func pop(_ animated: Bool = true) -> SLEx {
        base.navigationController?.popViewController(animated: animated)
        return self
    }
    
    @discardableResult
    func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> SLEx {
        base.present(vc, animated: animated, completion: completion)
        return self
    }
    
    @discardableResult
    func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) -> SLEx {
        base.dismiss(animated: animated, completion: completion)
        return self
    }
}
