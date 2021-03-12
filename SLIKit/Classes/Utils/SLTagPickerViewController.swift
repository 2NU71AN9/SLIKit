//
//  SLTagPickerViewController.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2021/3/11.
//  Copyright © 2021 SL. All rights reserved.
//

import UIKit
import TagListView
import pop

public class SLTagPickerViewController: UIViewController {
    
    static var primeColor: UIColor = .orange
    
    private var complete: (([(Int, String)]) -> Void)?
    private var titles: [(String, Bool)] = []
    private var multiple = false
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.textColor = Self.primeColor
            tagListView.borderColor = Self.primeColor
            tagListView.selectedBorderColor = Self.primeColor
            tagListView.tagSelectedBackgroundColor = Self.primeColor
            tagListView.textFont = SL.PingFang.font(name: .常规, size: 14)~~
            tagListView.delegate = self
        }
    }
    @IBOutlet weak var bottomGap: NSLayoutConstraint!
    
    convenience public init(_ titles: [String], multiple: Bool = false, complete: @escaping ([(Int, String)]) -> Void) {
        self.init(titles: titles.compactMap{($0, false)}, multiple: multiple, complete: complete)
    }
    convenience public init(_ selectTitles: [(String, Bool)], multiple: Bool = false, complete: @escaping ([(Int, String)]) -> Void) {
        self.init(titles: selectTitles, multiple: multiple, complete: complete)
    }
    
    init(titles: [(String, Bool)], multiple: Bool = false, complete: @escaping ([(Int, String)]) -> Void) {
        super.init(nibName: "SLTagPickerViewController", bundle: Bundle.sl.loadBundle(cls: Self.self, bundleName: "SLIKit"))
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.titles = titles
        self.multiple = multiple
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
        tagView.isSelected = !tagView.isSelected
        titles[tagView.tag - 200].1 = tagView.isSelected
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
    
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}
