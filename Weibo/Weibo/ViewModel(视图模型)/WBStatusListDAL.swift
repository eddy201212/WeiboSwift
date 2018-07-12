//
//  WBStatusListDAL.swift
//  Weibo
//
//  Created by Eddy on 2018/6/27.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

/// Data Access Layer 数据访问层
// 使命：负责处理数据库和网络数据，给 ListViewModel 返回微博的 [字典数组]
// 在调整系统的时候，尽量做最小化的调整

class WBStatusListDAL {
    
    /// 从本地数据库或者网络加载数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上拉刷新id
    ///   - completion: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion:@escaping(_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        //FIXME:从数据库读取数据
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                
                completion(nil, false)
                return
            }
            
            guard let list = list else {
                completion(nil, isSuccess)
                return
            }
            
            //FIXME:加载完成之后，将网络数据[字典数组]，同步写入数据库
            
            //返回数据网络
            completion(list, isSuccess)
        }
    }
    
}
