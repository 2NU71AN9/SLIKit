//
//  SLEditView.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/12/31.
//  Copyright © 2020 SL. All rights reserved.
//

#if canImport(RxSwift) && canImport(FSTextView)
import UIKit
import RxSwift
import FSTextView

@IBDesignable
public class SLEditView: UIView {
    
    /// 点击事件
    public var tapEvent: (() -> Void)?
    /// 只监听, 不要赋值
    public let textSubject = PublishSubject<String?>()
    
    @IBInspectable public dynamic var textFieldStyle: Bool = true {
        didSet {
            textField.isHidden = !textFieldStyle
            textView.isHidden = textFieldStyle || !editable
            textLabel.isHidden = textFieldStyle || editable
            if textFieldStyle {
                _ = textField.rx.text.orEmpty.bind(to: textSubject)
            } else {
                _ = textView.rx.text.orEmpty.bind(to: textSubject)
            }
        }
    }
    @IBInspectable public dynamic var required: Bool = false {
        didSet {
            requiredView.isHidden = !required
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
            subTitleLabel.isHidden = subTitle?.sl.noSpace.isEmpty ?? false
        }
    }
    // 0-无 1-右 2-下 3-上
    @IBInspectable public dynamic var arrowType: Int = 0 {
        didSet {
            arrowView.isHidden = !(arrowType == 1 || arrowType == 2 || arrowType == 3)
            arrowView.image =
                arrowType == 1 ? SLAssets.bundledImage(named: "arrow_right_black_15") :
                arrowType == 2 ? SLAssets.bundledImage(named: "arrow_down_black_15") :
                arrowType == 3 ? SLAssets.bundledImage(named: "arrow_up_black_15") : nil
        }
    }
    @IBInspectable public dynamic var titleColor: UIColor? = SLAssets.bundledColor(named: "sl_text_gray1") {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    @IBInspectable public dynamic var subColor: UIColor? = SLAssets.bundledColor(named: "sl_text_gray2") {
        didSet {
            subTitleLabel.textColor = subColor
        }
    }
    @IBInspectable public dynamic var textColor: UIColor? = SLAssets.bundledColor(named: "sl_label_color") {
        didSet {
            textField.textColor = textColor
            textView.textColor = textColor
            textLabel.textColor = textColor
        }
    }
    @IBInspectable public dynamic var titleFont: Int = 4 {
        didSet {
            titleLabel.font = SL.PingFang.font(index: titleFont, size: titleFontSize)
        }
    }
    @IBInspectable public dynamic var titleFontSize: CGFloat = 16 {
        didSet {
            titleLabel.font = SL.PingFang.font(index: titleFont, size: titleFontSize)
        }
    }
    @IBInspectable public dynamic var subFont: Int = 4 {
        didSet {
            subTitleLabel.font = SL.PingFang.font(index: subFont, size: subFontSize)
        }
    }
    @IBInspectable public dynamic var subFontSize: CGFloat = 14 {
        didSet {
            subTitleLabel.font = SL.PingFang.font(index: subFont, size: subFontSize)
        }
    }
    @IBInspectable public dynamic var textFont: Int = 5 {
        didSet {
            textField.font = SL.PingFang.font(index: textFont, size: textFontSize)
            textView.font = SL.PingFang.font(index: textFont, size: textFontSize)
            textLabel.font = SL.PingFang.font(index: textFont, size: textFontSize)
        }
    }
    @IBInspectable public dynamic var textFontSize: CGFloat = 17 {
        didSet {
            textField.font = SL.PingFang.font(index: textFont, size: textFontSize)
            textView.font = SL.PingFang.font(index: textFont, size: textFontSize)
            textLabel.font = SL.PingFang.font(index: textFont, size: textFontSize)
        }
    }
    @IBInspectable public dynamic var text: String? {
        didSet {
            textField.text = text
            textView.text = text
            textLabel.text = text
        }
    }
    // 0表示无限大
    @IBInspectable public dynamic var textCount: Int = 0 {
        didSet {
            textField.sl.maxCount(textCount)
            textView.maxLength = UInt(textCount)
        }
    }
    @IBInspectable public dynamic var placeholder: String = "请输入" {
        didSet {
            textField.placeholder = placeholder
            textView.placeholder = placeholder
        }
    }
    // textField和textView长按弹出剪贴,全选等操作
    @IBInspectable public dynamic var isPerform: Bool = true {
        didSet {
            textField.perform = isPerform
            textView.isCanPerformAction = isPerform
        }
    }
    // textField和textView是否可以编辑
    @IBInspectable public dynamic var editable: Bool = true {
        didSet {
            textView.isEditable = editable
            textView.isHidden = textFieldStyle || !editable
            textLabel.isHidden = textFieldStyle || editable
        }
    }
    // 数字键盘
    @IBInspectable public dynamic var numberKeyboard: Bool = false {
        didSet {
            textField.keyboardType = numberKeyboard ? .numberPad : .default
            textView.keyboardType = numberKeyboard ? .numberPad : .default
        }
    }
    // 内容缩进
    @IBInspectable public dynamic var contentInset: CGFloat = 0
    // 分隔线缩进
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
    
    private lazy var requiredView: UIImageView = {
        let view = UIImageView(image: SLAssets.bundledImage(named: "required6"))
        view.isHidden = !required
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 246), for: .horizontal)
        label.text = title
        label.textColor = titleColor
        label.font = UIFont(name: SL.PingFang.fontName(titleFont).rawValue, size: titleFontSize)
        return label
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 246), for: .horizontal)
        label.text = subTitle
        label.textColor = subColor
        label.font = SL.PingFang.font(index: subFont, size: subFontSize)
        label.isHidden = subTitle?.sl.noSpace.isEmpty ?? false
        return label
    }()
    private lazy var textField: SLNoPasteTextField = {
        let tf = SLNoPasteTextField()
        tf.setContentHuggingPriority(UILayoutPriority(rawValue: 245), for: .horizontal)
        tf.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 245), for: .horizontal)
        tf.isHidden = !textFieldStyle
        tf.text = text
        tf.textColor = textColor
        tf.textAlignment = .right
        tf.font = SL.PingFang.font(index: textFont, size: textFontSize)
        tf.sl.maxCount(textCount)
        tf.placeholder = placeholder
        tf.delegate = self
        tf.keyboardType = numberKeyboard ? .numberPad : .default
        tf.perform = isPerform
        if textFieldStyle {
            _ = tf.rx.text.orEmpty.bind(to: textSubject)
        }
        return tf
    }()
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = !(arrowType == 1 || arrowType == 2 || arrowType == 3)
        imageView.image =
            arrowType == 1 ? SLAssets.bundledImage(named: "arrow_right_black_15") :
            arrowType == 2 ? SLAssets.bundledImage(named: "arrow_down_black_15") :
            arrowType == 3 ? SLAssets.bundledImage(named: "arrow_up_black_15") : nil
        return imageView
    }()
    
    private lazy var textView: FSTextView = {
        let view = FSTextView()
        view.backgroundColor = .clear
        view.textColor = textColor
        view.isHidden = textFieldStyle || !editable
        view.isEditable = editable
        view.isCanPerformAction = isPerform
        view.placeholder = placeholder
        view.placeholderColor = SLAssets.bundledColor(named: "sl_view_gray3")
        view.maxLength = UInt(textCount)
        view.text = text
        view.font = SL.PingFang.font(index: textFont, size: textFontSize)
        view.keyboardType = numberKeyboard ? .numberPad : .default
        if !textFieldStyle {
            _ = view.rx.text.orEmpty.bind(to: textSubject)
        }
        return view
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = textColor
        label.isHidden = textFieldStyle || editable
        label.text = text
        label.font = SL.PingFang.font(index: textFont, size: textFontSize)
        return label
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
        let stackView = UIStackView(arrangedSubviews: [requiredView, titleStackView, textField, arrowView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var stackView3: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView2, textView, textLabel, lineView])
        stackView.axis = .vertical
        stackView.spacing = lineSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.sl.addTarget(self, action: #selector(tapAction))
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
        textLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentInset)
            make.right.equalToSuperview().offset(-contentInset)
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

#endif
