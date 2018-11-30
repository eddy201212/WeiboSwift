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
    
    func isIphoneXR() -> Bool {
        
        if UIScreen.main.bounds.size == CGSize(width: 414, height: 896) {
            
            return true
        }
        
        return false
    }
    
    func isIphoneXS_Max() -> Bool {
        
        if UIScreen.main.bounds.size == CGSize(width: 414, height: 896) {
            
            return true
        }
        
        return false
    }
    
    /// 是否iPhoneX 系列
    func isIphoneX_Series() -> Bool {
        
        return (isIphoneX() || isIphoneXR() || isIphoneXS_Max())
    }
}
