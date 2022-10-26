//
//  SLExpandLabel.swift
//  SLIKit
//
//  Created by 孙梁 on 2022/10/26.
//

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
        expandAction?()
    }
    
    private var expand = false
    private var allText: String?
    private var minline = 3
    private var expandText = "展开"
    private var expandTextColor: UIColor = .orange
    private var expandAction: (() -> Void)?
    
    public func setExpandLines(text: String?, expand: Bool, minline: Int, expandText: String = "展开", expandTextColor: UIColor, expandAction: @escaping () -> Void) {
        self.allText = text
        self.expand = expand
        self.minline = minline
        self.expandText = expandText
        self.expandTextColor = expandTextColor
        self.expandAction = expandAction
        expandBtn.isHidden = true
        guard !expand else {
            self.text = text
            return
        }
        let allText = getLines()
        guard allText.count > minline else { return }
        var textArray = Array(allText[0 ..< minline])
        var lastText = textArray.last ?? ""
        lastText.removeLast(expandText.count + 3)
        lastText.append("...")
        textArray.removeLast()
        textArray.append(lastText)
        self.text = textArray.joined()
        expandBtn.isHidden = false
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
    func getLines() -> [String] {
        guard let allText, let font else { return [] }
        let attributedString = NSMutableAttributedString(string: allText)
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
            let lineString = (allText as NSString).substring(with: range)
            lineArray.append(lineString)
        }
        return lineArray
    }
}
