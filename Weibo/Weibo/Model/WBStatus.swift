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
    
    @objc var create_at: String? {
        didSet {
            //FIXME:
        }
    }

    var createDate: Date?
    
    @objc var source: String? {
        didSet {
            //FIXME:
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
