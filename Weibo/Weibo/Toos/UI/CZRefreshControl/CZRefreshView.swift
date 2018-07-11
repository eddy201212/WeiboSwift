//
//  CZRefreshView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/11.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class CZRefreshView: UIView {

    // 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    // 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    // 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    var refreshState: CZRefreshState = .Normal {
        
        didSet {
            
            switch refreshState {
            case .Normal:
                
                // 恢复状态
                tipIcon.isHidden =  false
                indicator.stopAnimating()
                tipLabel.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel.text = "放手就刷新"
                
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.001))
                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                
                // 隐藏提示图标
                tipIcon?.isHidden = true
                
                // 显示菊花
                indicator?.startAnimating()
            }
        }
    }
    
    /// 父视图的高度 - 为了刷新控件不需要关心当前具体的刷新视图是谁！
    var parentViewHeight: CGFloat = 0
    
    /// 创建刷新视图
    ///
    /// - Returns: 刷新视图实例
    class func refreshView() -> CZRefreshView {
        
        let nib = UINib(nibName: "CZRefreshView", bundle: nil)
        
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! CZRefreshView
        
        return v
    }
}
