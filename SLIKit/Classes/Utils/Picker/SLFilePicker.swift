//
//  SLFilePicker.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/6/8.
//

import UIKit

public class SLFilePicker: NSObject {
    
    private var complete: ((URL, Data?) -> Void)?
    
    public func selectFile(_ complete: @escaping ((URL, Data?) -> Void)) {
        self.complete = complete
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
        let document = UIDocumentPickerViewController(documentTypes: documentTypes, in: .open)
        document.delegate = self
        SL.visibleVC?.present(document, animated: true, completion: nil)
    }
}

extension SLFilePicker: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else { return }
        SLICouldManager.download(withFileUrl: fileUrl) { [weak self] (fileData) in
            self?.complete?(fileUrl, fileData)
        }
        controller.dismiss(animated: true, completion: nil)
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
