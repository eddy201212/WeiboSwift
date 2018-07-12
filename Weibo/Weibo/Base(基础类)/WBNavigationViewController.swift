//
//  WBNavigationViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/12.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏系统的，使用自己创建的
        navigationBar.isHidden = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? WBBaseViewController{
                
                var title = "返回"
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: title, target: self, action: #selector(popToParent), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func popToParent() {
        popViewController(animated: true)
    }
}
