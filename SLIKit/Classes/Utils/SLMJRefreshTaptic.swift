//
//  SLMJRefreshTaptic.swift
//  DAOAProject
//
//  Created by 孙梁 on 2021/3/9.
//

import UIKit
import MJRefresh
import Haptica

public class SLMJRefreshTaptic: NSObject {
    @objc public static var enable: Bool = false {
        didSet {
            enable ? SLMJRefreshTaptic.begin() : ()
        }
    }
    private static var exchanged = false // 是否已经进行过
    private static func begin() {
        if exchanged { return }
        exchanged = true
        RunTime.exchangeMethod(selector: #selector(setter: MJRefreshComponent.state),
                               replace: #selector(MJRefreshComponent.sl_setState(_:)),
                               class: MJRefreshComponent.self)
    }
}

extension MJRefreshComponent {
    @objc func sl_setState(_ state: MJRefreshState) {
        sl_setState(state)
        if state == .pulling {
            Haptic.impact(.light).generate()
        }
    }
}
