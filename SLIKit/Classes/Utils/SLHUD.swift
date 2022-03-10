//
//  SLHUD.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/17.
//

import UIKit
import SwiftMessages
import ProgressHUD

public class SLHUD {
    
    /// 提示文字
    /// - Parameters:
    ///   - title: 标题(字体大, 加粗)
    ///   - desc: 内容
    ///   - duration: 持续时间/秒, 默认2, 0为永久
    ///   - position: 位置, 默认顶部
    ///   - btnTitle: 按钮文字, 默认无按钮, 设置按钮文字后持续时间未永久
    ///   - complete: 按钮点击
    public static func message(title: String? = nil, desc: String?, duration: Double = 2, position: SwiftMessages.PresentationStyle = .top, btnTitle: String? = nil, complete: (() -> Void)? = nil) {
        SL.mainThread {
            SwiftMessages.pauseBetweenMessages = 0
            SwiftMessages.hide(animated: false)
            if (title == nil || title?.count == 0) && (desc == nil || desc?.count == 0) { return }
            let haveBtn = !(btnTitle == nil || btnTitle?.count == 0)
            let duration = haveBtn ? 0 : duration
            let messageView = MessageView.viewFromNib(layout: .cardView)
            messageView.id = "10086"
            messageView.configureTheme(.info)
            messageView.configureContent(title: title, body: desc, iconImage: SLAssets.bundledImage(named: "info22"), iconText: nil, buttonImage: nil, buttonTitle: btnTitle) { _ in
                SwiftMessages.hide()
                complete?()
            }
            messageView.button?.isHidden = !haveBtn
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            config.preferredStatusBarStyle = .lightContent
            config.presentationStyle = position
            config.duration = duration == 0 ? .forever : .seconds(seconds: duration)
            SwiftMessages.show(config: config, view: messageView)
        }
    }
    
    /// Toast
    /// - Parameter title: 内容
    public static func toast(_ title: String?) {
        message(title: nil, desc: title, position: .bottom)
    }
    
    /// 设置loading&progress颜色, 遮罩颜色
    public static func loadingColor(_ color: UIColor?, maskColor: UIColor? = ProgressHUD.colorBackground) {
        guard let color = color else { return }
        ProgressHUD.colorAnimation = color
        ProgressHUD.colorProgress = color
        ProgressHUD.colorBackground = maskColor ?? ProgressHUD.colorBackground
    }
    
    /// 加载中...
    /// - Parameters:
    ///   - title: 文字
    ///   - animationType: 动画类型
    ///   - interaction: 是否可交互, 默认可以
    public static func loading(_ title: String?, animationType: AnimationType = .lineScaling, interaction: Bool = true) {
        SL.mainThread {
            ProgressHUD.animationType = .lineScaling
            ProgressHUD.show(title, interaction: interaction)
        }
    }
    
    /// 进度提示
    /// - Parameters:
    ///   - progress: 当前进度 0-1
    ///   - title: 文字
    ///   - yep: 完成后显示成功, 默认显示
    ///   - interaction: 是否可交互, 默认否
    public static func progress(_ progress: CGFloat, title: String? = nil, yep: Bool = true, interaction: Bool = false) {
        SL.mainThread {
            ProgressHUD.showProgress(title, progress)
            if progress >= 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    ProgressHUD.showSucceed(interaction: interaction)
                }
            }
        }
    }
    
    public static func dismissLoadingOrProgress() {
        SL.mainThread {
            ProgressHUD.dismiss()
        }
    }
    public static func dismissMessage() {
        SL.mainThread {
            SwiftMessages.hide()
        }
    }
}
