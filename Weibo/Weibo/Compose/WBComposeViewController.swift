//
//  WBComposeViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension WBComposeViewController {
    
    @objc func close() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func emoticonKeyboard() {
        
    }
}

extension WBComposeViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
        textView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
        
        if isIphoneX {
            toolbarBottomCons.constant = bottomSafeMargin
        }
        
        setupNavigationBar()
        setupToolbar()
    }
    
    fileprivate func setupNavigationBar() {
        
        navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        navigationItem.titleView = titleLabel
    }
    
    fileprivate func setupToolbar() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_toolbar_more"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            
            guard let imageName = dict["imageName"] else {
                
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHighLight = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.setImage(imageHighLight, for: .highlighted)
            btn.sizeToFit()
            items.append(UIBarButtonItem(customView: btn))
            
            if let actionName = dict["actionName"] {
                
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        
        toolbar.items = items;
    }
}
