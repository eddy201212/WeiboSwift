//
//  WBStatusViewModel.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBStatusViewModel: CustomStringConvertible {
    
    //微博模型
    var status: WBStatus
    
    //会员图标
    var memberIcon: UIImage?
    var vipIcon: UIImage?
    
    var retweetStr: String?
    var commentStr: String?
    var likeStr: String?
    
    var statusAttrText: NSMutableAttributedString?
    var retweetedAttrText: NSAttributedString?
    
    var pictureViewSize = CGSize()
    
    var picURLs: [WBStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    var rowHeight: CGFloat = 300
    
    init(model: WBStatus) {
        
        status = model
        
        if (model.user?.mbrank)! > 1 &&  (model.user?.mbrank)! < 7 {
            
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        retweetStr = countString(count: model.resosts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        pictureViewSize = calPictureViewSize(count: model.pic_urls?.count)
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        //let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        statusAttrText = NSMutableAttributedString(string: model.text ?? "")
        statusAttrText?.addAttributes([NSAttributedStringKey.font: originalFont], range: NSRange(location: 0, length: (statusAttrText?.length)!))
        
        //FIXME:
//        var rText = "@" +
    }
    
    func countString(count: Int, defaultStr: String) -> String {
        
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.2f 万", Double(count) / 10000)
    }
    
    func calPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        let row = (count! - 1) / 3 + 1
        
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    var description: String {
        return status.description
    }
}
