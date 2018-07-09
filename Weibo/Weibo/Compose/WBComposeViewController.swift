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

    /// 工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    /// 表情输入视图
    lazy var emoticonView = CZEmoticonInputView.inputView { (emoticon) in
        
        print(emoticon)
        
        // FIXME:插入表情
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 激活键盘
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 关闭键盘
        textView.resignFirstResponder()
    }
}

extension WBComposeViewController {
    
    @objc func close() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func emoticonKeyboard() {
        
        // 2> 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        // 3> !!!刷新键盘视图
        textView.reloadInputViews()
    }
    
    @objc private func keyboardChanged(n: Notification) {
        
        // 1. 目标 rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                return
        }
        
        // 2. 设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y
        
        // 3. 更新底部约束
        toolbarBottomCons.constant = offset
        
        // 4. 动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - 设置界面
extension WBComposeViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
        textView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
        toolbarBottomCons.constant = bottomSafeMargin
        
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

// MARK: - UITextViewDelegate
extension WBComposeViewController: UITextViewDelegate {
    
}
