//
//  WBNetworkManager+Extension.swift
//  Weibo
//
//  Created by Eddy on 2018/6/19.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

extension WBNetworkManager {
    
}

extension WBNetworkManager {

    //加载微博数据字典
    func statusList(since_id: Int64, max_id: Int64, completion:@escaping(_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(url: urlString, parameters: params) { (json, isSuccess) in
            
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result, isSuccess)
        }
    }
    
    //请求用户信息
    func loadUserInfo(completion:@escaping (_ dict: [String: AnyObject])->()) {
    
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid]
        
        tokenRequest(url: urlString, parameters: params) { (json, isSuccess) in
            
            completion(json as! [String: AnyObject])
        }
    }
}

extension WBNetworkManager {
    
    //请求访问acceesstoken
    func loadAccessToken(code: String, completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        request(url: urlString, method: .post, parameters: params) { (json, isSuccess) in
            
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            self.loadUserInfo(completion: { (dict) in
                
                self.userAccount.yy_modelSet(with: dict)
                
                self.userAccount.saveAccount()
                
                print("userInfo--\(self.userAccount)")
                
                completion(isSuccess)
            })
        }
    }
}
