//
//  SLImagePicker.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/13.
//

import UIKit
import HXPhotoPicker

public extension SLEx where Base: HXPhotoManager {
    
    @discardableResult
    func selectPortrait(_ complete: @escaping (UIImage?, HXPhotoModel?) -> Void) -> SLEx {
        base.configuration.singleSelected = true
        base.configuration.singleJumpEdit = true
        base.configuration.photoEditConfigur.aspectRatio = .type_1x1
        SL.visibleVC?.hx_presentSelectPhotoController(with: base, didDone: { (_, photoList, _, _, _, _) in
            photoList?.first?.requestFinalImage { (image) in
                complete(image, photoList?.first)
            }
        }, cancel: nil)
        return self
    }
    
    @discardableResult
    func maxNum(_ num: Int) -> SLEx {
        if num == 1 {
            base.configuration.singleSelected = true
        } else {
            base.configuration.photoMaxNum = UInt(num)
        }
        return self
    }
    
    @discardableResult
    func aspectRatio(_ ratio: HXPhotoEditAspectRatio) -> SLEx {
        base.configuration.singleJumpEdit = true
        base.configuration.photoEditConfigur.aspectRatio = ratio
        return self
    }
    
    @discardableResult
    func show(_ complete: @escaping ([HXPhotoModel]?) -> Void) -> SLEx {
        SL.visibleVC?.hx_presentSelectPhotoController(with: base, didDone: { (allList, photoList, videoList, isOriginal, vc, manager) in
            complete(photoList)
        }, cancel: nil)
        return self
    }
}

public extension HXPhotoModel {
    static let kQiNiuImageKey = UnsafeRawPointer(bitPattern: "qnImageKey".hashValue)!
    static let kUploadingKey = UnsafeRawPointer(bitPattern: "uploadingKey".hashValue)!
    static let kFinalImageKey = UnsafeRawPointer(bitPattern: "finalImageKey".hashValue)!

//    var qiNiuImage: QiniuImage? {
//        get {
//            return objc_getAssociatedObject(self, HXPhotoModel.qiNiuImageKey) as? QiniuImage
//        }
//        set {
//            if let qnToken = newValue {
//                objc_setAssociatedObject(self, HXPhotoModel.qiNiuImageKey, qnToken, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }

    var uploading: Bool {
        get {
            objc_getAssociatedObject(self, HXPhotoModel.kUploadingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, HXPhotoModel.kUploadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var finalImage: UIImage? {
        get {
            objc_getAssociatedObject(self, HXPhotoModel.kFinalImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, HXPhotoModel.kFinalImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func requestFinalImage(_ complete: @escaping (UIImage?) -> Void) {
        guard finalImage == nil else {
            complete(finalImage)
            return
        }
        if let localIdentifier = localIdentifier, asset == nil {
            let options = PHFetchOptions()
            asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: options).firstObject
        }
        if previewPhoto != nil {
            finalImage = previewPhoto
            complete(finalImage)
        } else if thumbPhoto != nil {
            finalImage = thumbPhoto
            complete(finalImage)
        } else {
            highQualityRequestThumbImage(withWidth: 1080) { [weak self] (image, model, _) in
                self?.finalImage = image
                complete(image)
            }
        }
    }

    func PHAsset2Image(asset: PHAsset?) -> UIImage? {
        guard let asset = asset else { return nil }
        var image: UIImage?
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption) { (result, _) -> Void in
            image = result
        }
        return image
    }
}
