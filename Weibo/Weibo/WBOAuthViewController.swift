//
//  WBOAuthViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/20.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    
    // MARK: - 控制器生命周期
    // TODO: 未完待续
    // FIXME: 修复
    override func loadView() {
        
        view = webView
        
        view.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        title = "登录"
        
        navigationItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "返回", target: self, action: #selector(close))
        navigationItem.rightBarButtonItems = UIBarButtonItem.fixtedSpace(title: "自动填充", target: self, action: #selector(autoFill))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}


// MARK: - UIWebViewDelegate
extension WBOAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            
            close()
            return false
        }

        print(request.url?.query ?? "")
        
        let code = request.url?.query?.suffix(from: "code=".endIndex) ?? ""
        
        print("code = \(code)")
        
        WBNetworkManager.shared.loadAccessToken(code: String(code)) { (isSuccess) in
            
            if !isSuccess {
                
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                
                SVProgressHUD.showInfo(withStatus: "登录成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
                self.close()
            }
        }
        
        return false
    }
}


// MARK: - 方法处理
extension WBOAuthViewController {
    
    @objc fileprivate func close() {
        
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func autoFill() {
        
        
    }
}
