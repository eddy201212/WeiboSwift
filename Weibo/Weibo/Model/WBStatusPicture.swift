//
//  WBStatusPicture.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBStatusPicture: NSObject {

    var thumbnail_pic: String? {
     
        didSet {
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
