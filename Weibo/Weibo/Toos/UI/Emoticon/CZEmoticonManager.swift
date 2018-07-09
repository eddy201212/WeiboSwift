//
//  CZEmoticonManager.swift
//  Emoticon
//
//  Created by Eddy on 2018/7/6.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation

class CZEmoticonManager {
    
    // 为了便于表情的复用，建立一个单例，只加载一次表情数据
    /// 表情管理器的单例
    static let shared = CZEmoticonManager()
    
    /// 表情包的懒加载数组 - 第一个数组是最近表情，加载之后，表情数组为空
    lazy var packages = [CZEmoticonPackage]()
    
    /// 表情素材的 bundle
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()
    
    /// 构造函数，如果在 init 之前增加 private 修饰符，可以要求调用者必须通过 shared 访问对象
    /// OC 要重写 allocWithZone 方法
    private init() {
        loadPackages()
    }
}

// MARK: - 表情包数据处理
extension CZEmoticonManager {
    
    // 读取 emoticons.plist
    // 只要按照 Bundle 默认的目录结构设定，就可以直接读取 Resources 目录下的文件
    
    func loadPackages() {
     
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
        let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
        let models = NSArray.yy_modelArray(with: CZEmoticonPackage.self, json: array) as? [CZEmoticonPackage]
        else {
                return
        }
        
        // 设置表情包数据
        // 使用 += 不需要再次给 packages 分配空间，直接追加数据
        packages += models
    }
}



