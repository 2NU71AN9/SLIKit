//
//  SLTagPickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/11.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit
import TagListView
import pop

public extension SLEx where Base: SLTagPickerViewController {
    @discardableResult
    func titles(_ titles: [String]) -> SLEx {
        base.titles = titles.compactMap{($0, false)}
        return self
    }
    
    @discardableResult
    func titles(_ titles: [(String, Bool)]) -> SLEx {
        base.titles = titles
        return self
    }
    
    @discardableResult
    func maxNum(_ num: Int) -> SLEx {
        base.maxNum = num
        return self
    }
    
    @discardableResult
    func primeColor(_ color: UIColor?) -> SLEx {
        base.primeColor = color ?? .orange
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> SLEx {
        base.font = font
        return self
    }
    
    @discardableResult
    func complete(_ complete: @escaping ([(Int, String)]) -> Void) -> SLEx {
        base.complete = complete
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.show()
        return self
    }
}


public class SLTagPickerViewController: UIViewController {
    
    fileprivate var primeColor: UIColor = .orange
    fileprivate var font = SL.PingFang.font(name: .常规, size: 14)
    fileprivate var complete: (([(Int, String)]) -> Void)?
    fileprivate var titles: [(String, Bool)] = []
    /// 最多选择多少, 0代表无限
    fileprivate var maxNum = 0
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.delegate = self
        }
    }
    @IBOutlet weak var bottomGap: NSLayoutConstraint!
    
    convenience public init(_ titles: [String], maxNum: Int = 0, complete: (([(Int, String)]) -> Void)?) {
        self.init(titles: titles.compactMap{($0, false)}, maxNum: maxNum, complete: complete)
    }
    convenience public init(_ selectTitles: [(String, Bool)], maxNum: Int = 0, complete: (([(Int, String)]) -> Void)?) {
        self.init(titles: selectTitles, maxNum: maxNum, complete: complete)
    }
    
    init(titles: [(String, Bool)], maxNum: Int = 0, complete: (([(Int, String)]) -> Void)?) {
        super.init(nibName: "SLTagPickerViewController", bundle: Bundle.sl.loadBundle(cls: Self.self, bundleName: "SLIKit"))
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.titles = titles
        self.maxNum = maxNum
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
        setUI()
        showAnim()
        for (index, item) in titles.enumerated() {
            let tagView = tagListView.addTag(item.0)
            tagView.isSelected = item.1
            tagView.tag = 200 + index
            tagView.onLongPress = nil
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        let selTitles = titles.enumerated().compactMap {
            $0.1.1 ? ($0.0, $0.1.0) : nil
        }
        complete?(selTitles)
        hide()
    }
}

extension SLTagPickerViewController: TagListViewDelegate {
    public func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if maxNum > 1 && sender.selectedTags().count >= maxNum && !tagView.isSelected {
            SLHUD.showToast("最多选择 \(maxNum) 项")
            return
        }
        tagView.isSelected = !tagView.isSelected
        titles[tagView.tag - 200].1 = tagView.isSelected
        if maxNum == 1 {
            sender.tagViews.forEach { $0.isSelected = ($0 == tagView && tagView.isSelected) }
            for (index, _) in titles.enumerated() {
                titles[index].1 = (tagView.tag - 200 == index && tagView.isSelected)
            }
        }
    }
}

public extension SLTagPickerViewController {
    private func showAnim() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = 0
        bottomGap.pop_add(anim, forKey: nil)
    }
    @objc private func hide() {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        anim?.toValue = -200
        bottomGap.pop_add(anim, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
    
    private func setUI() {
        tagListView.textColor = primeColor
        tagListView.borderColor = primeColor
        tagListView.selectedBorderColor = primeColor
        tagListView.tagSelectedBackgroundColor = primeColor
        tagListView.textFont = font~~
    }
    
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}
