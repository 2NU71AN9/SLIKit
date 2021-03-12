//
//  Ex_Image.swift
//  SLIKit
//
//  Created by Kevin on 2019/7/15.
//  Copyright © 2019 SL. All rights reserved.
//

import UIKit
import PKHUD

public extension SLEx where Base: UIImage {
    /// 保存图片到相册
    ///
    /// - Parameter complete: 成功或失败
    @discardableResult
    func save2PhotoAlbum() -> SLEx {
        UIImageWriteToSavedPhotosAlbum(base, base, #selector(base.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        return self
    }
}
public extension UIImage {
    @objc fileprivate func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            print("保存失败")
        }else{
            print("保存成功")
            HUD.showToast("保存成功")
        }
    }
}

