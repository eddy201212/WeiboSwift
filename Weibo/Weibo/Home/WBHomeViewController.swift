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

    lazy var statusList = [WBStatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    override func loadData() {
        
        WBNetworkManager.shared.statusList(since_id: 0, max_id: 0) { (list, isSuccess) in
            
            guard let userId = WBNetworkManager.shared.userAccount.uid else {
                return
            }
            
            print(userId)
            
            if !isSuccess {
                
                return
            }
            
            var array = [WBStatusViewModel]()
            
            for dic in list ?? [] {
                
                let status = WBStatus()
                status.yy_modelSet(with: dic)
                
                let vm = WBStatusViewModel(model: status)
                
                array.append(vm)
            }
            
            self.statusList += array
            
            self.tableView?.reloadData()
        }
    }
}

extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        let statusViewModel = statusList[indexPath.row]
        cell.textLabel?.text = statusViewModel.status.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension WBHomeViewController: WBStatusCellDelegate {
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        
        print("点击的url链接是\(urlString)")
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


