//
//  SLPresenter.swift
//  SLIKit
//
//  Created by 孙梁 on 2023/8/9.
//

import UIKit

public protocol SLPresenterAnimation {
    var contentView: UIView? { get }
    var fromTransform: CGAffineTransform { get }
}

public class SLPresenter: UIPresentationController {
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedView?.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        tap.delegate = self
        presentedView?.addGestureRecognizer(tap)
    }
    
    //弹框即将显示
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        
        if let ctr = presentedViewController as? SLPresenterAnimation {
            ctr.contentView?.transform = ctr.fromTransform
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut) {
                ctr.contentView?.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
    //弹框显示完毕
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }
    //弹框即将消失
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
        if let ctr = presentedViewController as? SLPresenterAnimation {
            UIView.animate(withDuration: 0.3) {
                ctr.contentView?.transform = ctr.fromTransform
            }
        }
    }
    //弹框消失之后
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
    }
}

extension SLPresenter: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = touch.view, v == presentedView {
            return true
        }
        return false
    }
}

extension SLPresenter {
    @objc private func dismissAction() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
