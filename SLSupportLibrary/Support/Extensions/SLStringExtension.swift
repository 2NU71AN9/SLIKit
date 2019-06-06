//
//  SLStringExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension String {
    /// 判断字符串是否是身份证
    var sl_isID: Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    /// 判断字符串是否是手机号
    var sl_isPhone: Bool {
        let regex = "^1[3|4|5|6|7|8|9][0-9]{9}$"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    /// 判断字符串是否是邮箱
    var sl_isMail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    /// 判断是不是车牌号
    var sl_isCarno: Bool {
        let regex = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Za-z]{1}[A-Za-z]{1}[A-Za-z0-9]{4}[A-Za-z0-9挂学警港澳]{1}$"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    /// 是否是中文
    var sl_isChinese: Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", "(^[\u{4e00}-\u{9fa5}]+$)")
        return pred.evaluate(with:self)
    }
    
    /// 获取字符串长度
    var sl_length: Int { return count }
    
    /// 去掉空格
    var sl_noSpace: String {
        let whitespace = CharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: whitespace)
    }
    
    /// 中文转拼音
    func sl_chinese2PinYin() -> String {
        //转化为可变字符串
        let mString = NSMutableString(string: self)
        //转化为带声调的拼音
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        //转化为不带声调
        CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        //转化为不可变字符串
        let string = NSString(string: mString)
        //去除字符串之间的空格
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    /// 时间戳 转 0000-00-00 00:00:00
    ///
    /// - Parameter timeStamp: 时间戳
    /// - Returns: 年月日时分秒
    var sl_timeStamp2Data: String {
        let timeSta: TimeInterval = (self as NSString).doubleValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dateFormatter.string(from: date)
    }
    
    /// 月份转时间Date
    var sl_stringMonth2Date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.date(from: self)
    }
}

extension String {
    
    /// 通过下标访问或赋值
    subscript(start:Int, length:Int) -> String {
        get {
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            return String(self[index1..<index2])
        }
        set {
            let tmp = self
            var s = ""
            var e = ""
            for (idx, item) in tmp.enumerated() {
                if (idx < start) {
                    s += "\(item)"
                }
                if (idx >= start + length) {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }
    
    /// 通过下标访问或赋值
    subscript(index:Int) -> String {
        get {
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set {
            let tmp = self
            self = ""
//            tmp.enumerateSubstrings(in: tmp.startIndex ..< tmp.index(tmp.startIndex, offsetBy: tmp.count)) { (str, inx, inx2, stop) in
//
//            }
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                } else {
                    self += "\(item)"
                }
            }
        }
    }
}
