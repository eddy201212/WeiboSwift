//
//  UIDevice+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/7/5.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

extension UIDevice {
    
     func isIphoneX() -> Bool {
        
        if UIScreen.main.bounds.size == CGSize(width: 375, height: 812) {
            
            return true
        }
        
        return false
    }
}
