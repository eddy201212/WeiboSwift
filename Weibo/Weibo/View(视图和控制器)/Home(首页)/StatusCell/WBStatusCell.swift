//
//  WBStatusCell.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SDWebImage

/**
 如果需要设置可选协议方法
 － 需要遵守 NSOBbjectProtcol 协议
 － 协议需要是 @objc 的
 － 方法需要 @objc optional
 
 */
@objc protocol WBStatusCellDelegate: NSObjectProtocol{
    
    @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}


class WBStatusCell: UITableViewCell {

    var viewModel: WBStatusViewModel? {
        
        didSet {
            statusLabel.attributedText = viewModel?.statusAttrText
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            
            iconView.wb_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            
            toolbar.viewModel = viewModel
            pictureView.viewModel = viewModel
            
            timeLabel.text = viewModel?.status.createdDate?.wb_dateDescription
            sourceLabel.text = viewModel?.status.source
        }
    }
    
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //名字
    @IBOutlet weak var nameLabel: UILabel!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    //微博正文
    @IBOutlet weak var statusLabel: UILabel!
    //图片视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    //底部工具栏
    @IBOutlet weak var toolbar: WBStatusToolBar!
    //转发微博正文
    @IBOutlet weak var retweetedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染 － 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格话 － 异步会址之后，会生出一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 ‘栅格化’ 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
