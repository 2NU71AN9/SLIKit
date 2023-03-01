//
//  SLWebViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/1/4.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit

public class SLWebViewController: UIViewController {
        
    public var url: URL? {
        didSet {
            webView.requestUrl = url
        }
    }
    
    private lazy var webView: SLWebView = {
        let view = SLWebView(url)
        view.titleSubject = { [weak self] title in
            self?.title = title
        }
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(SLAssets.bundledImage(named: "sl_close24"), for: .normal)
        btn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return btn
    }()
    
    public init(_ url: URL? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.bounds
        view.addSubview(webView)
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
    }
    
    @objc public func dismissAction() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if navigationController?.presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
