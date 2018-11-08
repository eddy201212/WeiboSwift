//
//  WBUserAccount.swift
//  Weibo
//
//  Created by Eddy on 2018/6/19.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import YYModel

fileprivate let accountFile = "/useraccount.json"

class WBUserAccount: NSObject {

    @objc var access_token: String?
    @objc var uid: String?
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    @objc var expiresDate: Date?
    
    @objc var screen_name: String?
    @objc var avatar_large: String?
    
    @objc override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let libarayPath = libarayPaths.first else {
            return
        }
        
        let filePath = libarayPath + accountFile
        
        guard let data = NSData(contentsOfFile: filePath),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
            return
        }
        
        yy_modelSet(with: dict ?? [:])
        
        //测试过期日期
        //expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("time out")
            
            access_token = nil
            uid = nil
            try? FileManager.default.removeItem(atPath: filePath)
        }
        
        print("normal--\(self)")
    }
    
    func saveAccount() {
        
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        dict.removeValue(forKey: "expires_in")
        
        let libarayPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let libarayPath = libarayPaths.first else {
            return
        }
        
        let filePath = libarayPath + accountFile
        
        (data as NSData).write(toFile: filePath, atomically: true)
    }
}
