//
//  WBComposeTypeView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/4.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import pop

fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
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
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    
    fileprivate var completionBlock: ((_ clsName: String?) -> ())?
    
    
    class func composeTypeView() -> WBComposeTypeView {
        
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! WBComposeTypeView
        
        //xib视图默认 600 * 600, 所以需要进行修改
        view.frame = UIScreen.main.bounds
        
        view.setupUI()
        
        return view
        
    }
    
    func show(completion: @escaping (_ clsName: String?)->()) {
        
        completionBlock =  completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        alpha = 0
        vc.view.addSubview(self)
        
        showCurrentView()
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        
        hideButtons()
    }
    
    @IBAction func clickReturnButton(_ sender: UIButton) {
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        returnButtonCenterXCons.constant = 0
        closeButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.alpha = 1
            self.returnButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setupUI()
    }
}

extension WBComposeTypeView {
    
    fileprivate func showCurrentView() {
        
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)

        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5

        pop_add(anim, forKey: nil)

        showButtons()
    }
    
    fileprivate func showButtons() {
        
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y + 300
            anim.toValue = btn.center.y
            anim.springBounciness = 8
            anim.springSpeed = 8
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
        }
    }
    
    fileprivate func hideButtons() {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated().reversed() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 380
            anim.springBounciness = 8
            anim.springSpeed = 8
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == 0 {
                anim.completionBlock = { (_, _) in
                    
                    self.hideCurrentView()
                }
            }
        }
    }
    
    fileprivate func hideCurrentView() {
        
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        anim.completionBlock = { (_, _) in
            
            self.removeFromSuperview()
        }
    }
}

extension WBComposeTypeView {
    
    @objc fileprivate func selectedButton(currentBtn: WBComposeTypeButton) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated() {
            
            let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            let scale = (btn == currentBtn) ? 2: 0.2
            anim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            anim.duration = 0.5
            btn.pop_add(anim, forKey: nil)
            
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                anim.completionBlock = { (_, _) in
                    
                    self.completionBlock?(currentBtn.clsName)
                }
            }
        }
    }
    
    @objc fileprivate func clickMore() {
        
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
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
        scrollView.clipsToBounds = false
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
            
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(selectedButton(currentBtn:)), for: .touchUpInside)
            }
            
            
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
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.width)
        }
    }
}
