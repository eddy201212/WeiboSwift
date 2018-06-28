//
//  WBStatusCell.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

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
            
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            
            
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
    @IBOutlet weak var pictureView: UIView!
    //底部工具栏
    @IBOutlet weak var toolbar: UIView!
    
}
