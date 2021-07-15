//
//  SLLanguageManager.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/7/14.
//

import UIKit

public class SLLanguageManager: NSObject {
    
    public static let shared = SLLanguageManager()
    private override init() {
        super.init()
        loadAvailableLanguages()
    }
    
    private var languageCodes: [String] = []
    /// 全部可用语言
    public private(set) var availableLanguages: [SLLanguage] = []
    /// 当前语言
    public private(set) var curLanguage: SLLanguage?
    
   
    private func loadAvailableLanguages() {
        guard let array = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String] else {
            return
        }
        languageCodes = array
        availableLanguages = array.compactMap {
            SLLanguage(code: $0)
        }
        availableLanguages.first?.isCurrent = true
        curLanguage = availableLanguages.first
    }
    
    /// 设置语言
    /// - Parameters:
    ///   - code: 语言码
    ///   - restart: 修改后重启
    public func setLanguage(with code: String, restart: Bool = true) {
        guard code != curLanguage?.code, let index = languageCodes.firstIndex(of: code) else { return }
        (languageCodes[0], languageCodes[index]) = (languageCodes[index], languageCodes[0])
        (availableLanguages[0], availableLanguages[index]) = (availableLanguages[index], availableLanguages[0])
        availableLanguages[index].isCurrent = false
        availableLanguages.first?.isCurrent = true
        curLanguage = availableLanguages.first
        UserDefaults.standard.setValue(languageCodes, forKey: "AppleLanguages")
        guard restart else { return }
        UIAlertController.sl.alert(.alert).title("修改语言后需要重启应用").action("立即重启", style: .default, custom: nil) { _ in
            abort()
        }.show()
    }
}

public class SLLanguage {
    public var isCurrent = false
    public var code: String?
    public var title: String?
    
    init(code: String) {
        self.code = code
        self.title = Locale.current.localizedString(forIdentifier: code)
    }
}
