//
//  WBHomeViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

/// 原创微博可重用 cell id
private let originalCellId = "originalCellId"
/// 被转发微博的可重用 cell id
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {

    /// 列表视图模型
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(browserPhoto), name: NSNotification.Name(WBStatusCellBrowserPhotoNotificaiton), object: nil)
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 加载数据
    override func loadData() {
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            
            print("加载数据结束)")
            
            if self.isPullup == true {
                self.refreshControl?.endRefreshing()
            }
            
            self.isPullup = false
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    
    /// 显示好友
    @objc fileprivate func showFriends() {
        
        print("showFriends...")
    }
    
    /// 浏览照片通知监听方法
    @objc fileprivate func browserPhoto(n: Notification) {
        
        // 1. 从 通知的 userInfo 提取参数
        guard let urls = n.userInfo?[WBStatusCellBrowserPhotoURLsKey] as? [String],
        let selectedIndex = n.userInfo?[WBStatusCellBrowserPhotoSelectedIndexKey] as? Int,
        let imageViewList = n.userInfo?[WBStatusCellBrowserPhotoImageViewKey] as? [UIImageView]
        else {
            return
        }
        
        // 2. 展现照片浏览控制器
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViewList)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - 表格数据源方法，具体的数据源方法实现，不需要 super
extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 0. 取出视图模型，根据视图模型判断可重用 cell
        let vm = listViewModel.statusList[indexPath.row]
        
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        // 1. 取 cell - 本身会调用代理方法(如果有)
        // 如果没有，找到 cell，按照自动布局的规则，从上向下计算，找到向下的约束，从而计算动态行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        
        // 2. 设置 cell
        cell.viewModel = vm
        
        // 设置代理只是传递了一个指针地址
        cell.delegate = self
        
        // 3. 返回 cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 1. 根据 indexPath 获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        
        // 2. 返回计算好的行高
        return vm.rowHeight
    }
}

// MARK: - WBStatusCellDelegate
extension WBHomeViewController: WBStatusCellDelegate {
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        
        print("点击的url链接是\(urlString)")
        
        let webVC = WBWebViewController()
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - 设置界面
extension WBHomeViewController {
    
    /// 重写父类的方法
    override func setUpViews() {

        super.setUpViews()
        
        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册原型 cell
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        // 设置行高
        // 取消自动行高
        tableView?.estimatedRowHeight = 300
        
        // 取消分隔线
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    fileprivate func setupNavTitle() {
        
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        
        navItem.titleView = button
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
}


