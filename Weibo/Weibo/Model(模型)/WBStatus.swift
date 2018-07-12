//
//  WBStatus.swift
//  Weibo
//
//  Created by Eddy on 2018/6/22.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBStatus: NSObject {

    @objc var id: Int64 = 0
    
    @objc var text : String?
    
    @objc var user: WBUser?
    
    @objc var created_at: String? {
        didSet {
            createdDate = Date.wb_sinaDate(string: created_at ?? "")
        }
    }

    var createdDate: Date?
    
    @objc var source: String? {
        didSet {
            // 重新计算来源并且保存
            // 在 didSet 中，给source 再次设置值，不会调用 didSet
            
            source = "来自" + (source?.wb_href()?.text ?? "")
        }
    }

    //被转发的原创微博
    @objc var retweeted_status: WBStatus?
    
    @objc var resosts_count: Int = 0
    @objc var comments_count: Int = 0
    @objc var attitudes_count: Int = 0
    
    @objc var pic_urls: [WBStatusPicture]?
    
    @objc override var description: String {
        return yy_modelDescription()
    }

    @objc class func modelContainerPropertyGenericClass() -> [String: AnyObject] {
        return ["pic_urls": WBStatusPicture.self]
    }
}
