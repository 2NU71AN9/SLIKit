//
//  SLAlertView.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit
import RxSwift
import pop

extension SLAlertView {
    /// 弹出1个按钮的提示框
    static func showSingleAlert(text: String, actionTitle: String, action: (() -> Void)?) {
        let slertView = SLAlertView(text: text, firstTitle: actionTitle, secondTitle: nil, firstAction: action, secondAction: nil)
        UIApplication.shared.keyWindow?.addSubview(slertView)
    }
    
    /// 弹出2个按钮的提示框
    static func showChoiceAlert(text: String, firstTitle: String, secondTitle: String, firstAction: (() -> Void)?, secondAction: (() -> Void)?) {
        let slertView = SLAlertView(text: text, firstTitle: firstTitle, secondTitle: secondTitle, firstAction: firstAction, secondAction: secondAction)
        UIApplication.shared.keyWindow?.addSubview(slertView)
    }
}

class SLAlertView: UIView {
    
    private let alertView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "balloon")
    }
    private let infoLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    private let firstBtn = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    private let secondBtn = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    private let bag = DisposeBag()
    
    private var single = true
    
    init(text: String, firstTitle: String, secondTitle: String?, firstAction: (() -> Void)?, secondAction: (() -> Void)?) {
        super.init(frame: SCREEN_BOUNS)
        backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.3134364298)
        
        addSubview(alertView)
        addSubview(titleImageView)
        alertView.addSubview(infoLabel)
        alertView.addSubview(firstBtn)
        if secondTitle != nil {
            single = false
            alertView.addSubview(secondBtn)
        }
        
        infoLabel.text = text
        firstBtn.setTitle(firstTitle, for: .normal)
        secondBtn.setTitle(secondTitle, for: .normal)
        
        firstBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.removeFromSuperview()
            firstAction?()
        }).disposed(by: bag)
        secondBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.removeFromSuperview()
            secondAction?()
        }).disposed(by: bag)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        newSuperview?.endEditing(true)
        let bgAnmi = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        bgAnmi?.springSpeed = 18
        bgAnmi?.fromValue = 0
        pop_add(bgAnmi, forKey: nil)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        alertView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.8)
            make.height.equalTo(SCREEN_WIDTH * 0.5)
        }
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(alertView.snp.top)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        firstBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            if single {
                make.width.equalToSuperview()
            }else{
                make.right.equalTo(alertView.snp.centerX)
            }
        }
        if !single {
            secondBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50)
                make.left.equalTo(firstBtn.snp.right)
            }
        }
        infoLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
            make.bottom.equalTo(firstBtn.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
