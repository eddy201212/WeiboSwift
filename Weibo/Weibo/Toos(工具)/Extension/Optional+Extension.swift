//
//  Optional+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/11/29.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

// MARK:- 判空（Emptiness）

extension Optional {
    
    /// 可选值为空的时候返回 true
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    
    /// 可选值非空返回 true
    var isSome: Bool {
        return !isNone
    }
}

/**
 
 // 使用前
 guard leftButton != nil, rightButton != nil else { fatalError("Missing Interface Builder connections") }
 
 // 使用后
 guard leftButton.isSome, rightButton.isSome else { fatalError("Missing Interface Builder connections") }
 
 
 */

