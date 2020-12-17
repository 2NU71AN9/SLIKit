//
//  Ex_UIAlertController.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/12/17.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

public extension UIAlertController {
    static func show(parent: UIViewController?, title: String?, message: String?, cancelTitle: String?, confirmTitle: String?, cancelComplete: (() -> Void)?, confirmComplete: (() -> Void)?) {
        weak var parent = parent
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelTitle = cancelTitle {
            let ac = UIAlertAction(title: cancelTitle, style: .default) { (_) in
                cancelComplete?()
            }
            alert.addAction(ac)
        }
        if let confirmTitle = confirmTitle {
            let ac = UIAlertAction(title: confirmTitle, style: .default) { (_) in
                confirmComplete?()
            }
            alert.addAction(ac)
        }
        parent?.present(alert, animated: true, completion: nil)
    }
}
