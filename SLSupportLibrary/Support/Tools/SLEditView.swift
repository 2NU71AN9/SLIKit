//
//  SLEditView.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/12/31.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import RxSwift
import FSTextView

@IBDesignable
public class SLEditView: UIView {
    
    /// 点击事件
    var tapEvent: (() -> Void)?
    /// 只监听, 不要赋值
    let textSubject = PublishSubject<String?>()
    
    @IBInspectable public dynamic var textFieldStyle: Bool = true {
        didSet {
            textField.isHidden = !textFieldStyle
            textView.isHidden = textFieldStyle
            if textFieldStyle {
                _ = textField.rx.text.orEmpty.bind(to: textSubject)
            } else {
                _ = textView.rx.text.orEmpty.bind(to: textSubject)
            }
        }
    }
    @IBInspectable public dynamic var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    @IBInspectable public dynamic var subTitle: String? {
        didSet {
            subTitleLabel.text = subTitle
            subTitleLabel.isHidden = subTitle?.sl_noSpace.isEmpty ?? false
        }
    }
    // 0-无 1-右 2-下
    @IBInspectable public dynamic var arrowType: Int = 0 {
        didSet {
            arrowView.isHidden = !(arrowType == 1 || arrowType == 2)
            arrowView.image =
                arrowType == 1 ? R.image.arrowRight15() :
                arrowType == 2 ? R.image.arrowDown15() : nil
        }
    }
    @IBInspectable public dynamic var titleColor: UIColor? = R.color.sl_text_gray1() {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    @IBInspectable public dynamic var subColor: UIColor? = R.color.sl_text_gray2() {
        didSet {
            subTitleLabel.textColor = subColor
        }
    }
    @IBInspectable public dynamic var titleFont: Int = 4 {
        didSet {
            titleLabel.font = UIFont(name: SLFontPingFang.fontName(titleFont).rawValue, size: titleFontSize)
        }
    }
    @IBInspectable public dynamic var titleFontSize: CGFloat = 16 {
        didSet {
            titleLabel.font = UIFont(name: SLFontPingFang.fontName(titleFont).rawValue, size: titleFontSize)
        }
    }
    @IBInspectable public dynamic var subFont: Int = 4 {
        didSet {
            subTitleLabel.font = UIFont(name: SLFontPingFang.fontName(subFont).rawValue, size: subFontSize)
        }
    }
    @IBInspectable public dynamic var subFontSize: CGFloat = 14 {
        didSet {
            subTitleLabel.font = UIFont(name: SLFontPingFang.fontName(subFont).rawValue, size: subFontSize)
        }
    }
    @IBInspectable public dynamic var textFont: Int = 5 {
        didSet {
            textField.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
            textView.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
        }
    }
    @IBInspectable public dynamic var textFontSize: CGFloat = 17 {
        didSet {
            textField.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
            textView.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
        }
    }
    @IBInspectable public dynamic var text: String? {
        didSet {
            textField.text = text
            textView.text = text
        }
    }
    // 0表示无限大
    @IBInspectable public dynamic var textCount: Int = 0 {
        didSet {
            textField.sl_maxCount = textCount
            textView.maxLength = UInt(textCount)
        }
    }
    @IBInspectable public dynamic var placeholder: String = "请输入" {
        didSet {
            textField.placeholder = placeholder
            textView.placeholder = placeholder
        }
    }
    // textField和textView是否可以编辑
    @IBInspectable public dynamic var editable: Bool = true {
        didSet {
            textView.isEditable = editable
        }
    }
    @IBInspectable public dynamic var numberKeyboard: Bool = false {
        didSet {
            textField.keyboardType = numberKeyboard ? .numberPad : .default
            textView.keyboardType = numberKeyboard ? .numberPad : .default
        }
    }
    @IBInspectable public dynamic var contentInset: CGFloat = 0
    @IBInspectable public dynamic var lineInset: CGFloat = 0
    @IBInspectable public dynamic var line: Bool = false {
        didSet {
            lineView.isHidden = !line
        }
    }
    @IBInspectable public dynamic var lineSpacing: CGFloat = 0 {
        didSet {
            stackView3.spacing = lineSpacing
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.font = UIFont(name: SLFontPingFang.fontName(titleFont).rawValue, size: titleFontSize)
        return label
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitle
        label.textColor = subColor
        label.font = UIFont(name: SLFontPingFang.fontName(subFont).rawValue, size: subFontSize)
        label.isHidden = subTitle?.sl_noSpace.isEmpty ?? false
        return label
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.isHidden = !textFieldStyle
        tf.text = text
        tf.textAlignment = .right
        tf.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
        tf.sl_maxCount = textCount
        tf.placeholder = placeholder
        tf.delegate = self
        tf.keyboardType = numberKeyboard ? .numberPad : .default
        if textFieldStyle {
            _ = tf.rx.text.orEmpty.bind(to: textSubject)
        }
        return tf
    }()
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = !(arrowType == 1 || arrowType == 2)
        imageView.image =
            arrowType == 1 ? R.image.arrowRight15() :
            arrowType == 2 ? R.image.arrowDown15() : nil
        return imageView
    }()
    
    private lazy var textView: FSTextView = {
        let view = FSTextView()
        view.backgroundColor = .clear
        view.isHidden = textFieldStyle
        view.isEditable = editable
        view.placeholder = placeholder
        view.placeholderColor = R.color.sl_view_gray3()
        view.maxLength = UInt(textCount)
        view.text = text
        view.font = UIFont(name: SLFontPingFang.fontName(textFont).rawValue, size: textFontSize)
        view.keyboardType = numberKeyboard ? .numberPad : .default
        if !textFieldStyle {
            _ = view.rx.text.orEmpty.bind(to: textSubject)
        }
        return view
    }()
    
    private lazy var lineView: SLLineView = {
        let view = SLLineView()
        view.isHidden = !line
        return view
    }()
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private lazy var stackView2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, textField, arrowView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var stackView3: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView2, textView, lineView])
        stackView.axis = .vertical
        stackView.spacing = lineSpacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addTarget(target: self, action: #selector(tapAction))
        return stackView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(stackView3)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView3)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(stackView3)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentInset)
            make.right.equalToSuperview().offset(-contentInset)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentInset-5)
            make.right.equalToSuperview().offset(-contentInset+5)
            make.height.greaterThanOrEqualTo(80)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(lineInset)
            make.right.equalToSuperview().offset(-lineInset)
        }
        stackView3.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        textField.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.height.greaterThanOrEqualTo(35)
        }
    }
}

extension SLEditView: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tapEvent?()
        return editable
    }
}

extension SLEditView {
    @objc private func tapAction() {
        tapEvent?()
    }
}
