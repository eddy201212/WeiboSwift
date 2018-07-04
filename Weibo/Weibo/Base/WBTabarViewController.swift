//
//  WBTabarViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/12.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBTabarViewController: UITabBarController {

    lazy fileprivate var composeButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_disable"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .selected)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .highlighted)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .selected)
        btn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        return btn
    }()
    
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        setupComposeButton()
        setupTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func userLogin(n: Notification) {
        
        let nav = UINavigationController(rootViewController: WBOAuthViewController())
        present(nav, animated: true, completion: nil)
    }
    
    //发布微博
    @objc fileprivate func composeStatus() {
        
        WBComposeTypeView.composeTypeView().show()
    }
}

extension WBTabarViewController {
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //FIXME:网络请求获取新微博数量
        
        tabBar.items?[0].badgeValue = "5"
        
        //授权才能显示
        UIApplication.shared.applicationIconBadgeNumber = 5
    }
}

extension WBTabarViewController {
    
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
    }
    
    fileprivate func setupControllers() {
        
        //沙盒
        let docDirect = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let json = (docDirect as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: json)
        
        // 如果沙盒中没有该文件，就从 Bundle 加载 data
        if data == nil {
            
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]] else {
            return;
        }
        
        var vcArray = [UIViewController]()
        
        for dict in array ?? [] {
            vcArray.append(controller(dict: dict))
        }
        
        viewControllers = vcArray
    }
    
    fileprivate func controller(dict: [String: AnyObject]) -> UIViewController {
        
        guard let className = dict["className"] as? String,
            let vcClass = ClassFromString(classString: className as NSString) as? WBBaseViewController.Type,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let visitorDict = dict["visitorInfo"] as? [String: String]
            else {
                return UIViewController()
        }
        
        let vc = vcClass.init()
        
        vc.title = title
        vc.visitorDictionary = visitorDict
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
        
        let nav = WBNavigationViewController(rootViewController: vc)
        
        return nav
    }
}

