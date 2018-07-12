//
//  String+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/7/4.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

extension String {
    
    // 返回’元组‘
    func wb_href() -> (link: String, text: String)? {
        
        // 常说的正则表达式，就是pattern的写法［匹配方案］
        // 索引：
        // 0: 和匹配方案完全一致的字符串
        // 1： 第一个（）中的内容
        // 2: 第二个（）中的内容
        // .... 索引从左向右顺序递增
        
        // 对于模糊匹配，如果关心的内容，就是用 (.*?) ，然后通过索引可以获取结果
        // 如果不关心的内容，就是 '.*?' ，可以匹配任意的内容
        
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        
        // 创建正则表达式，如果 pattern 失败，抛出异常
        
        // 进行查找，两种查找方法
        // [只找第一个匹配项／查找多个匹配项]
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []), let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
            else {
                return nil
        }
        
        
        // result 中质油两个重要的方法
        //  result.numberOfRanges -> 查找到的范围数量
        //  result.rangeAt(idx)   ->  指定‘索引’位置的范围
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
        
    }
}
