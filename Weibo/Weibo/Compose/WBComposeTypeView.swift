//
//  WBComposeTypeView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/4.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBCompViewController"],
                           ["imageName": "tabbar_compose_photo", "title": "照片／视频"],
                           ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                           ["imageName": "tabbar_compose_lbs", "title": "签到"],
                           ["imageName": "tabbar_compose_review", "title": "点评"],
                           ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                           ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                           ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                           ["imageName": "tabbar_compose_music", "title": "音乐"],
                           ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]


class WBComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    class func composeTypeView() -> WBComposeTypeView {
        
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! WBComposeTypeView
        
        //xib视图默认 600 * 600, 所以需要进行修改
        view.frame = UIScreen.main.bounds
        
        return view
        
    }
    
    func show() {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}

extension WBComposeTypeView {
    
    @objc fileprivate func selectedButton(btn: WBComposeTypeButton) {
        
    }
}

extension WBComposeTypeView {
    
    func setupUI() {
        
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        let width = UIScreen.main.bounds.width
        
        for i in 0..<2 {
            
            let view = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            
            scrollView.addSubview(view)
            addButton(v: view, idx: 6 * i)
        }
        
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
    }
    
    func addButton(v: UIView, idx: Int) {
        
        let count = 6
        
        for i in idx..<(idx + count) {
         
            if i >= buttonsInfo.count {
                continue
            }
            
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    continue
            }
            
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            v.addSubview(btn)
            
            btn.addTarget(self, action: #selector(selectedButton(btn:)), for: .touchDragInside)
            
            btn.clsName = dict["clsName"]
        }
        
        var btnSize = CGSize(width: 100, height: 100)
        var margin = (v.bounds.width - 3 * btnSize.width) / 4

        
        if UIScreen.main.bounds.width < (btnSize.width * 3 + margin * 4) {
            margin = 10

            let width = (UIScreen.main.bounds.width - 4 * margin) / 4
            btnSize = CGSize(width: width, height: width)
        }
        
        for (i, btn) in v.subviews.enumerated() {
            
            let y = i > 2 ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            
            let x = margin * CGFloat(col + 1) + CGFloat(col) * btnSize.width
            print("---\(i)---")
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.width)
        }
    }
}
