//
//  SLAddressPickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/2.
//

import UIKit
import pop
import HandyJSON

public class SLAddressPickerViewController: UIViewController {
    
    public enum AddressType {
        case province
        case city
        case area
    }

    fileprivate var complete: ((SLAddressModel?, SLAddressModel?, SLAddressModel?) -> Void)?
    fileprivate var type: AddressType = .area
    
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
        showAnim()
        loadData()
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
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
        if let path = Bundle.sl.moduleBundle(SLAddressPickerViewController.self)?.path(forResource: "SL_Address", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: [[String: Any]]],
           let p = dict["children"],
           let array = [SLAddressModel].deserialize(from: p) as? [SLAddressModel] {
            dataArray =  array
            picker.reloadAllComponents()
        }
    }
    
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

public class SLAddressModel: NSObject, HandyJSON {
    
    required public override init() { }
    
    var code = 0
    var pinyin: String?
    var alias: String?
    var provinceCode = 0
    var name: String?
    var firstLetter: String?
    var cityCode: String?
    var children: [SLAddressModel] = []
}
