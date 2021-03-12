//
//  Ex_StackView.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2021/3/5.
//  Copyright © 2021 SL. All rights reserved.
//

import Foundation
import UIKit

public extension SLEx where Base: UIStackView {
    
    @discardableResult
    func add(subviews views: [UIView]) -> SLEx {
        views.forEach { base.addArrangedSubview($0) }
        return self
    }
    
    @discardableResult
    func remove(subview view: UIView) -> SLEx {
        base.removeArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func remove(subviews views: [UIView]) -> SLEx {
        views.forEach { base.removeArrangedSubview($0) }
        return self
    }
    
    @discardableResult
    func insert(subview view: UIView, at:Int) -> SLEx {
        base.insertArrangedSubview(view, at: at)
        return self
    }
    
    @discardableResult
    func axis(_ a: NSLayoutConstraint.Axis) -> SLEx {
        base.axis = a
        return self
    }
    
    @discardableResult
    func distribution(_ a: UIStackView.Distribution) -> SLEx {
        base.distribution = a
        return self
    }
    
    @discardableResult
    func alignment(_ a: UIStackView.Alignment) -> SLEx {
        base.alignment = a
        return self
    }

    @discardableResult
    func spacing(_ a: CGFloat) -> SLEx {
        base.spacing = a
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func custom(_ spacing: CGFloat, after subview: UIView) -> SLEx {
        base.setCustomSpacing(spacing, after: subview)
        return self
    }
    
    /// 布局时是否参照基准线，默认是NO
    @discardableResult
    func isBaselineRelativeArrangement(_ a: Bool) -> SLEx {
        base.isBaselineRelativeArrangement = a
        return self
    }
    
    /// 设置布局时是否以控件的LayoutMargins为标准，默认为NO，是以控件的bounds为标准
    @discardableResult
    func isLayoutMarginsRelativeArrangement(_ a: Bool) -> SLEx {
        base.isLayoutMarginsRelativeArrangement = a
        return self
    }
}
