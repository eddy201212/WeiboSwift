//
//  Date+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/6/22.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

//日期格式化器 - 不要频繁的释放和创建，会影响性能
fileprivate let dateFormatter = DateFormatter()

// 当前日历对象
fileprivate let calendar = Calendar.current

extension Date {
    
    static func wb_sinaDate(string: String) -> Date? {
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        let date = dateFormatter.date(from: string)
        
        return date
    }

    var wb_dateDescription: String {
        
        if calendar.isDateInToday(self) {
            
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                
                return "刚刚"
            }
            
            if delta < 60 * 60 {
                
                return "\(delta / 60)分钟前"
            }
            
            return "\(delta / (60 * 60))小时前"
        }
        
        var fmt = "HH:mm"
        
        if calendar.isDateInYesterday(self) {
            
            fmt = "昨天" + fmt
        } else {
            
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                
                fmt = "yyyy-" + fmt
            }
        }
        
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}
