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
    var retweetedAttrText: NSMutableAttributedString?
    
    var pictureViewSize = CGSize()
    
    // 如果是被转发的微博，原创微博肯定没有图
    var picURLs: [WBStatusPicture]? {
        // 如果有被转发的微博，返回被转发微博的配图
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    var rowHeight: CGFloat = 0
    
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
        
        pictureViewSize = calPictureViewSize(count: picURLs?.count)
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        statusAttrText = NSMutableAttributedString(string: model.text ?? "")
        statusAttrText?.addAttributes([NSAttributedStringKey.font: originalFont], range: NSRange(location: 0, length: (statusAttrText?.length)!))
        
        let screenName = status.retweeted_status?.user?.screen_name
        let retweeted_status_text = status.retweeted_status?.text
        
        var rText = "@" + (screenName ?? "")
        rText = rText + ":" + (retweeted_status_text ?? "")
        
        
        retweetedAttrText = NSMutableAttributedString(string: rText)
        retweetedAttrText?.addAttributes([NSAttributedStringKey.font: retweetedFont], range: NSRange(location: 0, length: (retweetedAttrText?.length)!))
        
        updateRowHeight()
    }
    
    // 根据当前视图模型内容计算行高
    func updateRowHeight() {
        
        // 原创微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
        
        // 被转发微博：顶部分隔视图(12) ＋ 间距(12) ＋ 图片的高度(34) ＋ 间距(12) ＋ 正文高度(需要计算) ＋ 间距(12) ＋ 间距(12) ＋ 转发文本(高度需要计算) ＋ 配图视图(高度需要计算) ＋ 间距(12) ＋ 底部视图高度(35)
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
        
        height = 2 * margin + iconHeight + margin
        
        //正文高度
        if let text = statusAttrText {
            
            // usesLineFragmentOrigin：换行文本，统一使用
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        //判断是否是转发微博
        if status.retweeted_status != nil {

            height += 2 * margin

            //转发微博的高度
            if let text = retweetedAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        height += pictureViewSize.height
        height += margin
        height += toolbarHeight
        
        rowHeight = height
    }
    
    /// 使用单个图像，更新配图视图的大小
    ///
    /// 新浪针对单张图片，都是缩略图，但是偶尔会有一张特别大的图 7000 * 9000 多
    /// 新浪微博，为了鼓励原创，支持`长微博`，但是有的时候，有特别长的微博，长到宽度只有1个点
    ///
    /// - parameter image: 网路缓存的单张图像
    func updateSingleImageSize(image: UIImage) {
        
        var size = image.size
        
        let maxWidth: CGFloat = 200
        let minWidth: CGFloat = 40
        
        // 过宽图像处理
        if size.width > maxWidth {
            // 设置最大宽度
            size.width = 200
            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            
            // 要特殊处理高度，否则高度太大，会印象用户体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        // 过高图片处理，图片填充模式就是 scaleToFill，高度减小，会自动裁切
        if size.height > 200 {
            size.height = 200
        }
        
        // 特例：有些图像，本身就是很窄，很长！-> 定义一个 minHeight，思路同上！
        // 在工作中，如果看到代码中有些疑惑的分支处理！千万不要动！
        
        // 注意，尺寸需要增加顶部的 12 个点，便于布局
        size.height += WBStatusPictureViewOutterMargin
        
        // 重新设置配图视图大小
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
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
