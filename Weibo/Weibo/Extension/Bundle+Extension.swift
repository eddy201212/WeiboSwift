//
//  Bundle+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

extension Bundle {
    
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
