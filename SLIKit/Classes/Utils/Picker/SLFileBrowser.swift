//
//  SLFileBrowser.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/6/28.
//

import UIKit
import QuickLook

public class SLFileBrowser: QLPreviewController {
    
    private var fileUrl: URL?
    
    public init(_ fileUrl: URL) {
        super.init(nibName: nil, bundle: nil)
        delegate = self
        dataSource = self
        self.fileUrl = fileUrl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SLFileBrowser: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        fileUrl == nil ? 0 : 1
    }
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        (fileUrl ?? URL(fileURLWithPath: "")) as QLPreviewItem
    }
}

public extension SLFileBrowser {
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}
