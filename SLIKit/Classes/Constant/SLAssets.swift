//
//  SLAssets.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/1/4.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit

class SLAssets: NSObject {
    class func bundledImage(named name: String) -> UIImage? {
        let bundle = Bundle(for: SLAssets.self)
        guard let url = bundle.url(forResource: "SLIKit", withExtension: "bundle"),
                let imageBundle = Bundle(url: url),
                let path = imageBundle.path(forResource: name, ofType: "png") else {
            return nil
        }
        let image = UIImage(contentsOfFile: path)
        return image
//        let primaryBundle = Bundle(for: SLAssets.self)
//        if let image = UIImage(named: name, in: .module, compatibleWith: nil) {
//            return image
//        } else if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
//            return image
//        } else if let subBundleUrl = primaryBundle.url(forResource: "SLIKit", withExtension: "bundle"),
//                  let subBundle = Bundle(url: subBundleUrl),
//                  let image = UIImage(named: name, in: subBundle, compatibleWith: nil) {
//            return image
//        }
//        return UIImage()
    }
    
    class func bundledColor(named name: String) -> UIColor? {
        let primaryBundle = Bundle(for: SLAssets.self)
        if let color = UIColor(named: name, in: .module, compatibleWith: nil) {
            return color
        } else if let color = UIColor(named: name, in: primaryBundle, compatibleWith: nil) {
            return color
        } else if let subBundleUrl = primaryBundle.url(forResource: "SLIKit", withExtension: "bundle"),
                  let subBundle = Bundle(url: subBundleUrl),
                  let color = UIColor(named: name, in: subBundle, compatibleWith: nil) {
            return color
        }
        return nil
    }
}

private extension Bundle {
    static var module: Bundle { return Bundle(for: SLAssets.self) }
}
