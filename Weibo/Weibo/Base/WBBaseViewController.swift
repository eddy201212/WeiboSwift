//
//  WBBaseViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/12.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SnapKit

class WBBaseViewController: UIViewController{

    var userLogin = true
    
    var tableView: UITableView?
    
    var visitorDictionary: [String: String]?
    
    var refreshControl: UIRefreshControl?
    
    var isPullup = false
    
    //lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
    
    //添加navigationBar的容器，方便设置保持颜色一致
    lazy var navigationBarContainerView = UIView()
    lazy var navigationBar = UINavigationBar()
    lazy var navItem = UINavigationItem()
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 加载数据 － 具体的实现由子类负责
    func loadData() {
        // 如果子类不实现任何方法， 默认关闭
        refreshControl?.endRefreshing()
    }
}

fileprivate extension WBBaseViewController {
    
    @objc func loginSuccess() {
        print("loginSuccess")
        
        navItem.leftBarButtonItems = nil
        navItem.rightBarButtonItems = nil
        
        // 更新UI => 将访客视图替换为表格视图
        // 需要重新设置view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行viewDidLoad 会再次注册，避免通知被重新注册
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func login() {
        print("login")
        
       NotificationCenter.default.post(name: Notification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc func register() {
        print("register")
    }
}

extension WBBaseViewController {
    
    func setUpViews() {
        
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        WBNetworkManager.shared.userAccount.access_token != nil ? setupTableView() : setupVisitorView()
    }
    
    func setupVisitorView() {
        
        guard let visitorDict = visitorDictionary else {
            return
        }
        
        let visitorView = WBVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorDict
        view.insertSubview(visitorView, belowSubview: navigationBarContainerView)
        
        navItem.leftBarButtonItems = UIBarButtonItem.fixtedSpace(title: "注册", target: self, action: #selector(register))
        navItem.rightBarButtonItems = UIBarButtonItem.fixtedSpace(title: "登录", target: self, action: #selector(login))
    }
    
    //设置导航栏
    func setupNavigationBar() {
        
        view.addSubview(navigationBarContainerView)
        navigationBarContainerView.addSubview(navigationBar)

        navigationBarContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        navigationBar.snp.makeConstraints { make in

            if #available(iOS 11.0, *) {
                // iOS 11 and SnapKit 4.0
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                // iOS 10，如果没有升级 SnapKit 的话，可以使用 topLayoutGuide
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }

            make.bottom.leading.trailing.equalToSuperview()
        }
    
        navigationBar.items = [navItem]
    
        // 设置navBar的渲染颜色
        navigationBarContainerView.backgroundColor = UIColor.ColorHex(hex: "F6F6F6")
        navigationBar.barTintColor = UIColor.ColorHex(hex: "F6F6F6")
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBarContainerView)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        //tableView?.scrollIndicatorInsets = tableView!.contentInset
    }
    
    func loadMore() {
        print("more")
        
        isPullup = true
        loadData()
    }
}

extension WBBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
     // 基类只是准备方法，子类负责具体的实现，子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只是保证没有语法错误
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    // 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == (count - 1) && !isPullup {

            isPullup = true
            loadData()
        }
    }
}
