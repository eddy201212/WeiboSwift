//
//  WBComposeTextView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/9.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

/// 撰写微博的文本视图
class WBComposeTextView: UITextView {

    /// 占位符
    fileprivate lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    
    /// 监听方法
    @objc fileprivate func textChanged() {
        
        // 如果有文本，不显示占位标签，否则显示
        placeholderLabel.isHidden = self.hasText
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension WBComposeTextView {
    
    
    func insertEmoticon(em: CZEmoticon?) {
        
        // 1. em == nil 是删除按钮
        guard let em = em else {
            
            // 删除文本
            deleteBackward()
            
            return
        }
        
        // 2. emoji 字符串
        if let emoji = em.emoji,
        let textRange = selectedTextRange {
            
            // UITextRange 仅用在此处！
            replace(textRange, withText: emoji)
            
            return
        }
    }
}

// MARK: - 设置界面
extension WBComposeTextView {
    
    func setupUI() {
        
        // 0. 注册通知
        // - 通知是一对多，如果其他控件监听当前文本视图的通知，不会影响
        // - 但是如果使用代理，其他控件就无法使用代理监听通知！
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        // 1. 设置占位符标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
    }
}

