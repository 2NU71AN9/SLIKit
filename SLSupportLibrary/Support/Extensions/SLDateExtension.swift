//
//  SLDateExtension.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation

public extension Date {
    
    /// 获取当前年
    var sl_nowYear: Int {
        let curCalendar: Calendar = Calendar.current
        let year: Int = curCalendar.component(.year, from: self)
        return year
    }
    
    /// 获取当前月
    var sl_nowMonth: Int {
        let curCalendar: Calendar = Calendar.current
        let month: Int = curCalendar.component(.month, from: self)
        return month
    }
    
    /// 获取当前日
    var sl_nowDay: Int {
        let curCalendar: Calendar = Calendar.current
        let day: Int = curCalendar.component(.day, from: self)
        return day
    }
    
    /// 时间转换成年月
    var sl_date2YearMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: self)
    }
}
