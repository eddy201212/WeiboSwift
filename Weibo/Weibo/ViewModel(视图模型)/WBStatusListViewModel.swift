//
//  WBStatusListViewModel.swift
//  Weibo
//
//  Created by Eddy on 2018/6/27.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation
import Kingfisher
import SDWebImage

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
                self.cacheSingleImage(list: array, finished: completion)
            }
        }
    }
    
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - 应该缓存完单张图像，并且修改过配图是的大小之后，再回调，才能够保证表格等比例显示单张图像！
    ///
    /// - parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list: [WBStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 遍历数组，查找微博数据中有单张图像的，进行缓存
        // option + cmd + 左，折叠代码
        for vm in list {
            
            // 1> 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            // 2> 代码执行到此，数组中有且仅有一张图片
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            
            // print("要缓存的 URL 是 \(url)")
            
            // 3> 下载图像
            // 1) downloadImage 是 SDWebImage 的核心方法
            // 2) 图像下载完成之后，会自动保存在沙盒中，文件路径是 URL 的 md5
            // 3) 如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒地图像
            // 4) 不会发起网路请求，同时，回调方法，同样会调用！
            // 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网路请求！
            // *** 注意点：如果要缓存的图像累计很大，要找后台要接口！
            
            // A> 入组
            group.enter()
            
            
            SDWebImageDownloader.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, data, error, istrue) in
                // 将图像转换成二进制数据
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    // NSData 是 length 属性
                    length += data.count
                    
                    // 图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                
                print("缓存的图像是 \(String(describing: image)) 长度 \(length)")
                
                // B> 出组 - 放在回调的最后一句
                group.leave()
            })
            
            //            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
            //
            //
            //            })
        }
        
        // C> 监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成 \(length / 1024) K")
            
            // 执行闭包回调
            finished(true, true)
        }
    }
}
