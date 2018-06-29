//
//  WBHomeViewController.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

private let originalCellId = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func loadData() {
        
        print("加载……")
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            
            if self.isPullup == true {
                self.refreshControl?.endRefreshing()
            }
            
            self.isPullup = false
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
}

extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = listViewModel.statusList[indexPath.row]
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        cell.viewModel = vm
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
}

extension WBHomeViewController: WBStatusCellDelegate {
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        
        print("点击的url链接是\(urlString)")
        
        let webVC = WBWebViewController()
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

extension WBHomeViewController {
    
    override func setUpViews() {

        super.setUpViews()
        
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    fileprivate func setupNavTitle() {
        
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        
        navItem.titleView = button
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}


