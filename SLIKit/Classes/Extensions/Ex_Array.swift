//
//  Ex_Array.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/5.
//  Copyright © 2021 SL. All rights reserved.
//

import Foundation
import UIKit

public extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    /// 数组去重
    func sl_filter<E: Equatable>(_ repeated: (Element) -> E) -> [Element] {
        var result = [Element]()
        self.forEach { (e) in
            let key = repeated(e)
            let keys = result.map{repeated($0)}
            guard !keys.contains(key) else { return }
            result.append(e)
        }
        return result
    }
}
