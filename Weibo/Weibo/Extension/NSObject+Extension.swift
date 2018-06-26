//
//  NSObject+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

extension NSObject {
    
    func ClassFromString(classString: NSString?) -> AnyClass? {
        
        var getClassName: AnyClass?
        
        if let classString = classString {
            
            getClassName = NSClassFromString(Bundle.main.namespace + "." + (classString as String))
        }
        
        return getClassName
    }
}
