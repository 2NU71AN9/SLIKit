//
//  SLFilePickerViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/6/28.
//

import UIKit

public extension SLEx where Base: SLFilePickerViewController {
    @discardableResult
    func complete(_ complete: @escaping (URL, Data?) -> Void) -> SLEx {
        base.complete = complete
        return self
    }
    
    @discardableResult
    func show() -> SLEx {
        base.show()
        return self
    }
}

public class SLFilePickerViewController: UIDocumentPickerViewController {

    fileprivate var complete: ((URL, Data?) -> Void)?
    
    public init(_ complete: ((URL, Data?) -> Void)?) {
        let documentTypes = ["public.content",
                             "public.text",
                             "public.source-code",
                             "public.image",
                             "public.audiovisual-content",
                             "com.adobe.pdf",
                             "com.apple.keynote.key",
                             "com.microsoft.word.doc",
                             "com.microsoft.excel.xls",
                             "com.microsoft.powerpoint.ppt"]
        super.init(documentTypes: documentTypes, in: .open)
        self.complete = complete
        delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SLFilePickerViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        SLICouldManager.download(withFileUrl: fileUrl) { [weak self] (fileData) in
            self?.complete?(fileUrl, fileData)
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

public extension SLFilePickerViewController {
    func show() {
        SL.visibleVC?.present(self, animated: true, completion: nil)
    }
}


public class SLICouldManager {
    
    public static func iCouldEnable() -> Bool {
        FileManager.default.url(forUbiquityContainerIdentifier: nil) != nil
    }
    
    public static func download(withFileUrl url: URL, completion: ((Data?) -> Void)? = nil) {
        let document = SLDocument(fileURL: url)
        document.open { (success) in
            if success { document.close(completionHandler: nil) }
            completion?(document.data)
        }
    }
}

public class SLDocument: UIDocument {
    
    public var data: Data?
    
    public override func load(fromContents contents: Any, ofType typeName: String?) throws {
        data = contents as? Data
    }
}
