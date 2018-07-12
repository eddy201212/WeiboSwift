//
//  WBStatusPicture.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBStatusPicture: NSObject {

    /// 缩略图地址
    @objc var thumbnail_pic: String? {
     
        didSet {
            
            // 设置大尺寸图片
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            // 更改缩略图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    /// 大尺寸图片
    @objc var largePic: String?
    
    @objc override var description: String {
        return yy_modelDescription()
    }
}
