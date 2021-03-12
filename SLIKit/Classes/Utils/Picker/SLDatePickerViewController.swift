//
//  SLDatePickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/3/4.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import pop

public extension SLEx where Base: SLDatePickerViewController {
    @discardableResult
    func mode(_ mode: UIDatePicker.Mode) -> SLEx {
        base.mode = mode
        return self
    }
    
    @discardableResult
    func date(_ date: Date) -> SLEx {
        base.initDate = date
        return self
    }
    
    @discardableResult
    func minDate(_ date: Date) -> SLEx {
        base.minDate = date
        return self
    }
    
    @discardableResult
    func maxDate(_ date: Date) -> SLEx {
        base.maxDate = date
        return self
    }
    
    @discardableResult
    func complete(_ complete: @escaping (Date) -> Void) -> SLEx {
        base.complete = complete
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.show()
        return self
    }
}


public class SLDatePickerViewController: UIViewController {

    fileprivate var mode: UIDatePicker.Mode = .date
    fileprivate var initDate = Date()
    fileprivate var minDate: Date?
    fileprivate var maxDate: Date?
    fileprivate var complete: ((Date) -> Void)?

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewHeight: NSLayoutConstraint! {
        didSet {
            viewHeight.constant = 266 + SL.bottomHeight
        }
    }
    @IBOutlet weak var bottomGap: NSLayoutConstraint!

    public override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = mode
        datePicker.date = initDate
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        showAnim()
    }

    convenience public init(_ mode: UIDatePicker.Mode, initDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, complete: ((Date) -> Void)?) {
        self.init(mode: mode, initDate: initDate, minDate: minDate, maxDate: maxDate, complete: complete)
    }
    
    init(mode: UIDatePicker.Mode, initDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, complete: ((Date) -> Void)?) {
        super.init(nibName: "SLDatePickerViewController", bundle: Bundle.sl.loadBundle(cls: Self.self, bundleName: "SLIKit"))
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.mode = mode
        self.initDate = initDate ?? Date()
        self.minDate = minDate
        self.maxDate = maxDate
        self.complete = complete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if touches.contains(where: { $0.view == view }) {
            hide()
        }
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        complete?(datePicker.date)
        hide()
    }
}

extension SLDatePickerViewController: UIPickerViewDelegate {

}

public extension SLDatePickerViewController {
    private func showAnim() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = 0
        bottomGap.pop_add(anim, forKey: nil)
    }
    
    @objc private func hide() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = -266
        bottomGap.pop_add(anim, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}
