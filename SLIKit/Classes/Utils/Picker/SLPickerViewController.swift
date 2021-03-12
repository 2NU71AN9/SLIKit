//
//  SLPickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/3/13.
//  Copyright © 2020 2UN7. All rights reserved.
//

import UIKit
import pop

public extension SLEx where Base: SLPickerViewController {
    @discardableResult
    func titles(_ titles: [String]) -> SLEx {
        base.titles = titles
        return self
    }
    
    @discardableResult
    func complete(_ complete: @escaping (Int, String) -> Void) -> SLEx {
        base.complete = complete
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.show()
        return self
    }
}


public class SLPickerViewController: UIViewController {

    fileprivate var complete: ((Int, String) -> Void)?
    fileprivate var titles: [String] = []

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
        }
    }
    @IBOutlet weak var viewHeight: NSLayoutConstraint! {
        didSet {
            viewHeight.constant = 266 + SL.bottomHeight
        }
    }
    @IBOutlet weak var bottomGap: NSLayoutConstraint!
    
    convenience public init(_ titles: [String], complete: ((Int, String) -> Void)?) {
        self.init(titles: titles, complete: complete)
    }
    
    init(titles: [String], complete: ((Int, String) -> Void)?) {
        super.init(nibName: "SLPickerViewController", bundle: Bundle.sl.loadBundle(cls: Self.self, bundleName: "SLIKit"))
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.titles = titles
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

    public override func viewDidLoad() {
        super.viewDidLoad()
        showAnim()
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        let index = picker.selectedRow(inComponent: 0)
        complete?(index, titles[index])
        hide()
    }
}

extension SLPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        titles.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        titles[row]
    }
}

public extension SLPickerViewController {
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
