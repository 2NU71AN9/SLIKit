//
//  SLExpandLabel.swift
//  SLIKit
//
//  Created by 孙梁 on 2022/10/26.
//

#if canImport(SnapKit)

import UIKit
import CoreText

public class SLExpandLabel: UILabel {
    
    private lazy var expandBtn: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = expandText
        label.font = font
        label.textColor = expandTextColor
        label.sl.addTarget(self, action: #selector(moreClick))
        return label
    }()
    
    @objc private func moreClick() {
        expand ? closeAction?() : expandAction?()
    }
    
    private var expand = false
    private var allText: String?
    private var minline = 3
    private var expandText = "展开"
    private var closeText = "收起"
    private var expandTextColor: UIColor = .orange
    private var expandAction: (() -> Void)?
    private var closeAction: (() -> Void)?

    public func setExpandLines(text: String?, expand: Bool, minline: Int, expandText: String = "展开", closeText: String = "收起", expandTextColor: UIColor, expandAction: @escaping () -> Void, closeAction: @escaping () -> Void) {
        self.allText = text
        self.expand = expand
        self.minline = minline
        self.expandText = expandText
        self.closeText = closeText
        self.expandTextColor = expandTextColor
        self.expandAction = expandAction
        self.closeAction = closeAction
        expandBtn.isHidden = true
        
        if expand {
            // 展开状态
            guard let text else {
                self.text = text
                return
            }
            let allText = getLines(allText)
            guard allText.count > minline else {
                self.text = text
                return
            }
            self.text = text + "\n"
            expandBtn.text = closeText
            expandBtn.isHidden = false
        } else {
            // 收起状态
            let allText = getLines(allText)
            guard allText.count > minline else {
                self.text = text
                return
            }
            var textArray = Array(allText[0 ..< minline])
            var lastText = textArray.last ?? ""
            lastText.removeLast(expandText.count + 3)
            lastText.append("...")
            textArray.removeLast()
            textArray.append(lastText)
            self.text = textArray.joined()
            expandBtn.text = expandText
            expandBtn.isHidden = false
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        addSubview(expandBtn)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        expandBtn.sizeToFit()
        expandBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }
}

extension SLExpandLabel {
    func getLines(_ text: String?) -> [String] {
        guard let text, let font else { return [] }
        let attributedString = NSMutableAttributedString(string: text)
        let realFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: realFont, range: NSRange(location: 0, length: attributedString.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect.init(origin: .zero, size: CGSize(width: bounds.width, height: 10000)), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CFIndex(0), CFIndex(0)), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return [] }
        var lineArray: [String] = []
        for line in lines {
            let lineRef = line
            let lineRange: CFRange? = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange?.location ?? 0, length: lineRange?.length ?? 0)
            let lineString = (text as NSString).substring(with: range)
            lineArray.append(lineString)
        }
        return lineArray
    }
}

#endif
