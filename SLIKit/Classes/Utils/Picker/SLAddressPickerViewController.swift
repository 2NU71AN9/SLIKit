//
//  SLAddressPickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/2.
//

import UIKit

public extension SLEx where Base: SLAddressPickerViewController {
    @discardableResult
    func type(_ type: SLAddressPickerViewController.AddressType) -> SLEx {
        base.type = type
        return self
    }
    
    @discardableResult
    func complete(_ complete: @escaping (SLAddressModel?, SLAddressModel?, SLAddressModel?) -> Void) -> SLEx {
        base.complete = complete
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.show()
        return self
    }
}


public class SLAddressPickerViewController: UIViewController {
    
    public enum AddressType {
        case province
        case city
        case area
    }

    fileprivate var complete: ((SLAddressModel?, SLAddressModel?, SLAddressModel?) -> Void)?
    fileprivate var type: AddressType = .area
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
        }
    }
    
    private var dataArray: [SLAddressModel] = []
    private var p_index = 0 {
        didSet {
            picker.selectRow(p_index, inComponent: 0, animated: false)
            if type != .province {
                picker.reloadComponent(1)
                c_index = 0
            }
        }
    }
    private var c_index = 0 {
        didSet {
            picker.selectRow(c_index, inComponent: 1, animated: false)
            if type != .city {
                picker.reloadComponent(2)
                a_index = 0
            }
        }
    }
    private var a_index = 0 {
        didSet {
            picker.selectRow(a_index, inComponent: 2, animated: false)
        }
    }
    
    convenience public init(_ type: AddressType = .area, complete: ((SLAddressModel?, SLAddressModel?, SLAddressModel?) -> Void)?) {
        self.init(type: type, complete: complete)
    }
    
    init(type: AddressType = .area, complete: ((SLAddressModel?, SLAddressModel?, SLAddressModel?) -> Void)?) {
        super.init(nibName: "SLAddressPickerViewController", bundle: Bundle.sl.loadBundle(cls: Self.self, bundleName: "SLIKit"))
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.type = type
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
        contentView.transform = CGAffineTransform(translationX: 0, y: 300)
        loadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnim()
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        guard dataArray.count > 0 else { return }
        switch type {
        case .province:
            complete?(dataArray[p_index], nil, nil)
        case .city:
            complete?(dataArray[p_index], dataArray[p_index].children[c_index], nil)
        case .area:
            complete?(dataArray[p_index], dataArray[p_index].children[c_index], dataArray[p_index].children[c_index].children[a_index])
        }
        hide()
    }
}

extension SLAddressPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        type == .province ? 1 : type == .city ? 2 : 3
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return dataArray.count
        case 1:
            return dataArray[p_index].children.count
        default:
            return dataArray[p_index].children[c_index].children.count
        }
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return dataArray[row].name
        case 1:
            return dataArray[p_index].children[row].name
        default:
            return dataArray[p_index].children[c_index].children[row].name
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            p_index = row
        case 1:
            c_index = row
        default:
            a_index = row
        }
    }
}

public extension SLAddressPickerViewController {
    
    private func loadData() {
        if let bundle = Bundle.sl.loadBundle(cls: Self.self, bundleName: "my"),
           let dict = bundle.sl.loadPlist(with: "SL_Address") as? [String: [[String: Any]]],
           let p = dict["children"] {
            dataArray = p.compactMap {
                let model = SLAddressModel()
                model.setValuesForKeys($0)
                return model
            }
            picker.reloadAllComponents()
        }
    }
    
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

public class SLAddressModel: NSObject {
    @objc public var code = 0
    @objc public var pinyin: String?
    @objc public var alias: String?
    @objc public var provinceCode = 0
    @objc public var name: String?
    @objc public var firstLetter: String?
    @objc public var cityCode = 0
    @objc public var children: [SLAddressModel] = []
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "children", let value = value as? [[String: Any]] {
            children = value.compactMap {
                let model = SLAddressModel()
                model.setValuesForKeys($0)
                return model
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
