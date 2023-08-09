//
//  SLCustomPresentationController.swift
//  SLIKit
//
//  Created by 孙梁 on 2023/8/8.
//

import UIKit

public protocol SLCustomPresentationRect {
    var viewRect: CGRect { get }
}

public class SLCustomPresentationController: UIPresentationController {
    
    private lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewClick))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    //决定了弹出框的frame
//    override var frameOfPresentedViewInContainerView: CGRect {
//        (presentedViewController as? SLCustomPresentationRect)?.viewRect ?? .zero
//    }
    
    //重写此方法可以在弹框即将显示时执行所需要的操作
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha = 1
        }
    }
    
    //重写此方法可以在弹框显示完毕时执行所需要的操作
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }

    //重写此方法可以在弹框即将消失时执行所需要的操作
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha = 0
        }
    }

    //重写此方法可以在弹框消失之后执行所需要的操作
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = (presentedViewController as? SLCustomPresentationRect)?.viewRect ?? .zero
    }
}

extension SLCustomPresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
