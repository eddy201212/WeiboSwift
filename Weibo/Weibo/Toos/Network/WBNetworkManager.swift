//
//  WBNetworkManager.swift
//  Weibo
//
//  Created by Eddy on 2018/6/13.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import Alamofire

class WBNetworkManager {
    
    static let shared: WBNetworkManager = {
       
        let instance = WBNetworkManager()
        return instance
    }()
    
    lazy var userAccount = WBUserAccount()
    
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    func tokenRequest(url: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil, name: String? = nil, data: Data? = nil, completion:@escaping(_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        guard let token = userAccount.access_token else {
            
            NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        
        if parameters == nil {
            
            parameters = [String :AnyObject]()
        }
        
        parameters!["access_token"] = token
        
        if let name = name, let data = data {
            
            print("\(name) -- \(data)")
            //上传
            
        } else {
            
            request(url: url, method: method, parameters: parameters, completion: completion)
        }
    }
    
    func request(url: URLConvertible,
                       method: HTTPMethod = .get,
                       parameters: Parameters? = nil,
                       completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            
           
            guard let result = response.result.value else {
                
                if (response.response)?.statusCode == 403 {
                    
                    print("token outtime")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
                }
                
                completion(nil, false)
                return
            }
            
            completion(result as AnyObject, true)
        }
    }
}
