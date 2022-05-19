//
//  SLWebView.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/1/4.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit
import WebKit

public class SLWebView: WKWebView {
    
    public var titleSubject: ((String?) -> Void)?
    public var urlChanged: ((URL?) -> Void)?

    @IBInspectable public dynamic var progressColor: UIColor? = UIColor.blue {
        didSet {
            progress.tintColor = progressColor
        }
    }
    @IBInspectable public dynamic var progressHeight: CGFloat = 1
    
    public var requestUrl: URL? {
        didSet {
            guard let url = requestUrl else { return }
            load(URLRequest(url: url))
        }
    }
    
    private lazy var progress: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = progressColor
        view.trackTintColor = .clear
        view.setProgress(0.1, animated: true)
        view.alpha = 0
        return view
    }()

    private var config = WKWebViewConfiguration().then {
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width,initial-scale=1.0,user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].setAttribute('width', '100%');imgs[i].style.height='auto';}"
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        $0.userContentController = wkUController
    }
    
    public init(_ url: URL?) {
        super.init(frame: CGRect.zero, configuration: config)
        requestUrl = url
        setup()
    }
    public init() {
        super.init(frame: CGRect.zero, configuration: config)
        setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        // xib初始化没有设置configuration
        setup()
    }
    
    private func setup() {
        addSubview(progress)
        addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        addObserver(self, forKeyPath: "title", options: .new, context: nil)
        addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        guard let url = requestUrl else { return }
        load(URLRequest(url: url))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        progress.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(safeAreaInsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(progressHeight)
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "estimatedProgress")
        removeObserver(self, forKeyPath: "title")
        removeObserver(self, forKeyPath: "URL")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let object = object as? WKWebView {
            progress.alpha = 1
            progress.setProgress(Float(estimatedProgress), animated: true)
            if estimatedProgress >= 1.0 {
                urlChanged?(object.url)
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    self?.progress.alpha = 0
                }) { [weak self] (_) in
                    self?.progress.setProgress(0, animated: true)
                }
            }
        } else if keyPath == "title", let _ = object as? WKWebView {
            titleSubject?(title)
        } else if keyPath == "URL", let object = object as? WKWebView {
            urlChanged?(object.url)
        }
    }
}
