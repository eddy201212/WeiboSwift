//
//  WBWebViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/27.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {

    var urlString: String? {
        
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    let frame = UIScreen.main.bounds
    
    lazy var webView: UIWebView = {
        let webV = UIWebView()
        webV.frame = CGRect(x: 0, y: navigationBarHeight, width: screenWidth, height: screenHeight - navigationBarHeight)
        webV.backgroundColor = UIColor.white
        webV.isOpaque = false
        return webV
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WBWebViewController {
    
    override func setupTableView() {
        
        navItem.title = "网页"
        
        view.insertSubview(webView, belowSubview: navigationBarContainerView)
    }
}
