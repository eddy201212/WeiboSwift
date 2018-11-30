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
        
        if let size = UIScreen.main.currentMode?.size, size == CGSize(width: 1125, height: 2436) {
            
            return true
        }
        
        return false
    }
    
    func isIphoneXR() -> Bool {
        
        if let size = UIScreen.main.currentMode?.size, size == CGSize(width: 828, height: 1792) {
            
            return true
        }
        
        return false
    }
    
    func isIphoneXS_Max() -> Bool {
        
        if let size = UIScreen.main.currentMode?.size, size == CGSize(width: 1242, height: 2688) {
            
            return true
        }
        
        return false
    }
    
    /// 是否iPhoneX 系列
    func isIphoneX_Series() -> Bool {
        
        return (isIphoneX() || isIphoneXR() || isIphoneXS_Max())
    
    }
}
