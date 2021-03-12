//
//  SLLineView.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/12/31.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit

@IBDesignable
public class SLLineView: UIView {

    @IBInspectable public dynamic var horizontal: Bool = true
    @IBInspectable public dynamic var lineWidth: CGFloat = 0.4
    @IBInspectable public dynamic var lineColor: UIColor? = SLAssets.bundledColor(named: "sl_view_gray2") {
        didSet {
            backgroundColor = lineColor
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = lineColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = lineColor
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = lineColor
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        snp.makeConstraints { (make) in
            if horizontal {
                make.height.equalTo(lineWidth)
            } else {
                make.width.equalTo(lineWidth)
            }
        }
    }
}
