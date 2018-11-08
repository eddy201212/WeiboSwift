//
//  WBComposeViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textView: WBComposeTextView!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    /// 工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    /// 表情输入视图
    lazy var emoticonView = CZEmoticonInputView.inputView { (emoticon) in

        self.textView.insertEmoticon(em: emoticon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
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
    
    /// 发布微博
    @IBAction func postStatus() {
        
        // 1. 获取发送给服务器的表情微博文字
        let text = textView.emoticonText
        print("发送微博的内容\(text)")
        
        // 2. 发布微博
        WBNetworkManager.shared.postStatus(text: textView.text) { (result, isSuccess) in

            // 修改指示器样式
            SVProgressHUD.setDefaultStyle(.dark)

            let message = isSuccess ? "发布成功" : "网络不给力"

            SVProgressHUD.showInfo(withStatus: message)

            // 如果成功，延迟一段时间关闭当前窗口
            if isSuccess {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {

                    // 恢复样式
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }
        }
    }
    
    
    /// 切换表情键盘
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
        
        sendButton.isEnabled = false
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
/**
 通知：一对多，只要有注册的监听者，在注销监听之前，都可以接收到通知！
 代理：一对一，最后设置的代理对象有效！
 
 苹果日常开发中，代理的监听方式是最多的！
 
 - 代理是发生事件时，直接让代理执行协议方法！
 代理的效率更高
 直接的反向传值
 - 通知是发生事件时，将通知发送给通知中心，通知中心再`广播`通知！
 通知想对要低一些
 如果层次嵌套的非常深，可以使用通知传值
 */
extension WBComposeViewController: UITextViewDelegate {
    
    /// 文本视图文字变化
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}
