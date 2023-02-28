//
//  SLDatePickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/3/4.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit

public extension SLEx where Base: SLDatePickerViewController {
    @discardableResult
    func mode(_ mode: UIDatePicker.Mode) -> SLEx {
        base.mode = mode
        return self
    }
    
    @discardableResult
    func date(_ date: Date?) -> SLEx {
        base.initDate = date ?? Date()
        return self
    }
    
    @discardableResult
    func minDate(_ date: Date?) -> SLEx {
        base.minDate = date
        return self
    }
    
    @discardableResult
    func maxDate(_ date: Date?) -> SLEx {
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

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    public override func viewDidLoad() {
        super.viewDidLoad()
        contentView.transform = CGAffineTransform(translationX: 0, y: 500)
        datePicker.datePickerMode = mode
        datePicker.date = initDate
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.contentView.transform = CGAffineTransform(translationX: 0, y: 500)
            self?.dismiss(animated: true)
        }
    }
    
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}
