//
//  WBVisitorView.swift
//  Weibo
//
//  Created by Eddy on 2018/6/15.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SnapKit

class WBVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var visitorInfo: [String: String]? {
        
        didSet {
            
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    lazy fileprivate var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    lazy fileprivate var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    lazy fileprivate var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()
    
    fileprivate func startAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        
        //循环播放，动画完成不删除
        anim.isRemovedOnCompletion = false
        //将动画添加到图层，但控件销毁，动画也会一起被销毁
        iconView.layer.add(anim, forKey: nil)
    }
}

extension WBVisitorView {
    
    func setupViews() {
        
        backgroundColor = UIColor.ColorHex(hex: "ededed")
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        let margin: CGFloat = 20.0
        
        iconView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        maskIconView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
    
        houseIconView.snp.makeConstraints { (make) in
            
            make.center.equalTo(iconView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(iconView.snp.bottom)
            make.centerX.equalTo(iconView)
            make.width.equalTo(236)
        }
        
        registerButton.snp.makeConstraints { (make) in
            
            make.left.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(margin)
            make.width.equalTo(100)
        }
        
        loginButton.snp.makeConstraints { (make) in
            
            make.right.equalTo(tipLabel)
            make.top.equalTo(registerButton)
            make.width.equalTo(registerButton)
        }
        
    }
}
