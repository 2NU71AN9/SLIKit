//
//  SLWaveAnimationView.swift
//  SLIKit
//
//  Created by 孙梁 on 2023/2/14.
//

import UIKit

public class SLWaveAnimationView: UIView {
    // 波纹颜色
    @IBInspectable
    public var waveColor: UIColor = UIColor.red
    // 放大几倍
    @IBInspectable
    public var scale: CGFloat = 2.0
    
    // 透明度动画
    private lazy var opacityAnimation: CABasicAnimation = {
        let opacityA = CABasicAnimation(keyPath: "opacity")
        opacityA.fromValue = 1
        opacityA.toValue = 0
        return opacityA
    }()
    // 波纹动画
    private lazy var scaleAnimation: CABasicAnimation = {
        let scaleA = CABasicAnimation(keyPath: "transform")
        scaleA.fromValue = CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0)
        scaleA.toValue = CATransform3DScale(CATransform3DIdentity, scale, scale, 0)
        return scaleA
    }()
    // 动画组
    private lazy var animationGroup: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.animations = [opacityAnimation, scaleAnimation]
        group.duration = 3.0 // 动画执行时间
        group.repeatCount = HUGE // 最大重复
        group.autoreverses = false
        group.isRemovedOnCompletion = false
        return group
    }()
    // 动画layer
    private lazy var animationLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.fillColor = waveColor.cgColor
        // 默认初始颜色透明度
        layer.opacity = 0
        return layer
    }()
    /// 需要重复的动态波，数量，缩放起始点
    private lazy var replicator: CAReplicatorLayer = {
        let replicator = CAReplicatorLayer()
        replicator.frame = animationLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 1.0
        replicator.addSublayer(animationLayer)
        replicator.zPosition = -1
        return replicator
    }()
    
    deinit {
        stopAnim()
    }
}

extension SLWaveAnimationView {
    public func startAnim() {
        layer.addSublayer(replicator)
        animationLayer.add(animationGroup, forKey: "wave")
    }
    public func stopAnim() {
        animationLayer.removeAnimation(forKey: "wave")
        replicator.removeFromSuperlayer()
    }
}
