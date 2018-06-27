//
//  WBStatusListViewModel.swift
//  Weibo
//
//  Created by Eddy on 2018/6/27.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation
import Kingfisher

//微博数据列表视图模型

//上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    lazy var statusList = [WBStatusViewModel]()
    
    //上次刷新错误次数
    private var pullupErrorTimes = 0
    
    func loadStatus(pullup: Bool, completion:@escaping(_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            
            completion(false, false)
            return
        }
        
        //下拉刷新，取出数组中第一条微博的ID
        let since_id = pullup ? 0 : self.statusList.first?.status.id ?? 0
        //上拉刷新，取出数组的最后一条微博ID
        let max_id = !pullup ? 0 : self.statusList.last?.status.id ?? 0
        
        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
                return
            }
            
            var array = [WBStatusViewModel]()
            
            for dict in list ?? [] {
                
                let status = WBStatus()
                status.yy_modelSet(with: dict)
                let viewModel = WBStatusViewModel(model: status)
                array.append(viewModel)
            }
            
            print("刷新到\(array.count)条")
            
            if pullup {
                self.statusList += array
            } else {
                self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                //FIXME:
                completion(isSuccess, true)
            }
        }
    }
}
