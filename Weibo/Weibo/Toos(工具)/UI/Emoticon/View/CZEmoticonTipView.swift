//
//  CZEmoticonTipView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/10.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import pop

/// 表情选择提示视图
class CZEmoticonTipView: UIImageView {

    /// 之前选择的表情
    private var preEmoticon: CZEmoticon?
    
    /// 提示视图的表情模型
    var emoticon: CZEmoticon?{
        
        didSet {
            
            // 判断表情是否变化
            if emoticon == preEmoticon  {
                return
            }
            
            // 记录当前的表情
            preEmoticon = emoticon
            
            // 设置表情数据
            tipButton.setTitle(emoticon?.emoji, for: .normal)
            tipButton.setImage(emoticon?.image, for: .normal)
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = 30
            anim.toValue = 8
            
            anim.springBounciness = 20
            anim.springSpeed = 20
            
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    }
    
    // MARK: - 私有控件
    private lazy var tipButton = UIButton()
    
    // MARK: - 构造函数
    init() {
        
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
     
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 添加按钮
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        
        tipButton.setTitle("😄", for: .normal)
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
