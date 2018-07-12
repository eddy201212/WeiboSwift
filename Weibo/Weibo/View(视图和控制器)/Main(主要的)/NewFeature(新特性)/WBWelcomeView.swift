//
//  WBWelcomeView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/12.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    /// 图标宽度约束
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func welcomeView() -> WBWelcomeView {
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! WBWelcomeView
        
        // 从 XIB 加载的视图，默认是 600 * 600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }

    
    /// 从xib加载完成调用
    override func awakeFromNib() {
         super.awakeFromNib()
        
        // 1. 设置圆角(iconView的 bounds 还没有设置)
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
        
        // 2. url
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else {
                return
        }
        
        // 3. 设置头像 - 如果网络图像没有下载完成，先显示占位图像
        // 如果不指定占位图像，之前设置的图像会被清空！
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"), options: [], completed: nil)
    }
    
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 XIB 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 300
        
        // 如果控件们的 frame 还没有计算好！所有的约束会一起动画！
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            
            // 更新约束
            self.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = CGFloat(1)
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}
